import Flutter
import CoreBluetooth
import UIKit

class BlePrintPlugin: NSObject, FlutterPlugin, CBCentralManagerDelegate, CBPeripheralDelegate {

    static let CHANNEL = "ble_print_service"
    static let CHUNK_SIZE = 512
    static let WRITE_DELAY = 0.05 // 50ms

    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral?
    private var writeCharacteristic: CBCharacteristic?

    private var scanResults: [CBPeripheral] = []
    private var isScanning = false
    private var scanTimer: Timer?

    // Completion handlers
    private var connectCompletion: ((Bool) -> Void)?
    private var discoverCompletion: ((Bool) -> Void)?
    private var writeCompletion: ((Bool) -> Void)?
    private var scanCompletion: (([[String: String]]) -> Void)?

    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: registrar.messenger())
        let instance = BlePrintPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "send":
            guard let args = call.arguments as? [String: Any],
                  let deviceId = args["deviceId"] as? String,
                  let data = args["data"] as? FlutterStandardTypedData,
                  let serviceUuidStr = args["serviceUuid"] as? String,
                  let writeCharUuidStr = args["writeCharUuid"] as? String else {
                result(FlutterError(code: "INVALID_ARGS", message: "Missing required arguments", details: nil))
                return
            }

            sendData(deviceId: deviceId,
                    data: data.data,
                    serviceUuid: serviceUuidStr,
                    writeCharUuid: writeCharUuidStr,
                    result: result)

        case "scanDevices":
            let args = call.arguments as? [String: Any]
            let duration = args?["duration"] as? Int ?? 5000
            scanDevices(duration: duration, result: result)

        case "stopScan":
            stopScan()
            result(true)

        case "isBluetoothEnabled":
            result(centralManager.state == .poweredOn)

        case "enableBluetooth":
            // iOS doesn't allow programmatic enable
            // User must enable via Settings
            result(centralManager.state == .poweredOn)

        case "connect":
            guard let args = call.arguments as? [String: Any],
                  let deviceId = args["deviceId"] as? String else {
                result(FlutterError(code: "INVALID_ARGS", message: "Device ID is null", details: nil))
                return
            }
            connectDevice(deviceId: deviceId, result: result)

        case "disconnect":
            disconnectDevice(result: result)

        case "isConnected":
            result(peripheral?.state == .connected)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Send Data

    private func sendData(deviceId: String, data: Data, serviceUuid: String, writeCharUuid: String, result: @escaping FlutterResult) {
        // 1. Connect
        connectDevice(deviceId: deviceId) { [weak self] connected in
            guard let self = self, connected else {
                result(FlutterError(code: "CONNECTION_ERROR", message: "Failed to connect", details: nil))
                return
            }

            // 2. Discover services
            self.discoverServices(serviceUuid: serviceUuid, writeCharUuid: writeCharUuid) { discovered in
                guard discovered else {
                    self.disconnectDevice(result: nil)
                    result(FlutterError(code: "DISCOVERY_ERROR", message: "Failed to discover services", details: nil))
                    return
                }

                // 3. Write data in chunks
                self.writeDataInChunks(data: data) { success in
                    // 4. Disconnect
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.disconnectDevice(result: nil)
                        result(success)
                    }
                }
            }
        }
    }

    private func connectDevice(deviceId: String, completion: @escaping (Bool) -> Void) {
        connectCompletion = completion

        // Find peripheral from scan results or create new
        if let found = scanResults.first(where: { $0.identifier.uuidString == deviceId }) {
            peripheral = found
            centralManager.connect(found, options: nil)
        } else {
            // Try to retrieve peripheral by identifier
            let uuid = UUID(uuidString: deviceId)
            if let uuid = uuid {
                let peripherals = centralManager.retrievePeripherals(withIdentifiers: [uuid])
                if let peripheral = peripherals.first {
                    self.peripheral = peripheral
                    centralManager.connect(peripheral, options: nil)
                    return
                }
            }
            completion(false)
        }
    }

    private func connectDevice(deviceId: String, result: @escaping FlutterResult) {
        connectDevice(deviceId: deviceId) { connected in
            result(connected)
        }
    }

    private func disconnectDevice(result: FlutterResult?) {
        if let peripheral = peripheral {
            centralManager.cancelPeripheralConnection(peripheral)
        }
        peripheral = nil
        writeCharacteristic = nil
        result?(true)
    }

    private func discoverServices(serviceUuid: String, writeCharUuid: String, completion: @escaping (Bool) -> Void) {
        discoverCompletion = completion

        guard let peripheral = peripheral else {
            completion(false)
            return
        }

        peripheral.delegate = self

        let serviceUUID = CBUUID(string: serviceUuid)
        peripheral.discoverServices([serviceUUID])
    }

    private func writeDataInChunks(data: Data, completion: @escaping (Bool) -> Void) {
        guard let peripheral = peripheral,
              let characteristic = writeCharacteristic else {
            completion(false)
            return
        }

        // Split into chunks
        let chunks = stride(from: 0, to: data.count, by: Self.CHUNK_SIZE).map {
            data[$0..<min($0 + Self.CHUNK_SIZE, data.count)]
        }

        var currentIndex = 0

        func writeNextChunk() {
            guard currentIndex < chunks.count else {
                completion(true)
                return
            }

            let chunk = chunks[currentIndex]
            peripheral.writeValue(chunk, for: characteristic, type: .withResponse)

            currentIndex += 1

            // Wait for write response before sending next chunk
            writeCompletion = { success in
                guard success else {
                    completion(false)
                    return
                }

                // Delay before next chunk
                DispatchQueue.main.asyncAfter(deadline: .now() + Self.WRITE_DELAY) {
                    writeNextChunk()
                }
            }
        }

        writeNextChunk()
    }

    // MARK: - Scan

    private func scanDevices(duration: Int, result: @escaping FlutterResult) {
        guard !isScanning else {
            result(FlutterError(code: "ALREADY_SCANNING", message: "Scan already in progress", details: nil))
            return
        }

        // Check Bluetooth state
        switch centralManager.state {
        case .poweredOn:
            break // Continue with scan
        case .poweredOff:
            result(FlutterError(code: "BLUETOOTH_OFF", message: "Bluetooth is turned off. Please enable Bluetooth in Settings.", details: nil))
            return
        case .unauthorized:
            result(FlutterError(code: "PERMISSION_DENIED", message: "Bluetooth permission denied. Please enable Bluetooth permission in Settings > Happy Puppy POS.", details: nil))
            return
        case .unsupported:
            result(FlutterError(code: "BLE_NOT_AVAILABLE", message: "Bluetooth Low Energy is not supported on this device.", details: nil))
            return
        case .unknown, .resetting:
            result(FlutterError(code: "BLUETOOTH_UNAVAILABLE", message: "Bluetooth is currently unavailable. Please try again.", details: nil))
            return
        @unknown default:
            result(FlutterError(code: "BLUETOOTH_ERROR", message: "Unknown Bluetooth state.", details: nil))
            return
        }

        scanResults.removeAll()
        isScanning = true

        scanCompletion = { devices in
            result(devices)
        }

        centralManager.scanForPeripherals(withServices: nil, options: nil)

        // Stop scan after duration
        let durationSeconds = Double(duration) / 1000.0
        scanTimer = Timer.scheduledTimer(withTimeInterval: durationSeconds, repeats: false) { [weak self] _ in
            self?.stopScan()

            let devices = self?.scanResults.map { peripheral in
                return [
                    "name": peripheral.name ?? "Unknown",
                    "id": peripheral.identifier.uuidString
                ]
            } ?? []

            self?.scanCompletion?(devices)
            self?.isScanning = false
        }
    }

    private func stopScan() {
        if isScanning {
            centralManager.stopScan()
            scanTimer?.invalidate()
            scanTimer = nil
            isScanning = false
        }
    }

    // MARK: - CBCentralManagerDelegate

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("[BlePrint] Bluetooth state: \(central.state.rawValue)")
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !scanResults.contains(where: { $0.identifier == peripheral.identifier }) {
            scanResults.append(peripheral)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("[BlePrint] Connected to \(peripheral.name ?? "Unknown")")
        connectCompletion?(true)
        connectCompletion = nil
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("[BlePrint] Failed to connect: \(error?.localizedDescription ?? "Unknown")")
        connectCompletion?(false)
        connectCompletion = nil
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("[BlePrint] Disconnected")
    }

    // MARK: - CBPeripheralDelegate

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil, let services = peripheral.services else {
            discoverCompletion?(false)
            discoverCompletion = nil
            return
        }

        // Discover characteristics for first service
        if let service = services.first {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard error == nil, let characteristics = service.characteristics else {
            discoverCompletion?(false)
            discoverCompletion = nil
            return
        }

        // Find write characteristic
        writeCharacteristic = characteristics.first { char in
            char.properties.contains(.write) || char.properties.contains(.writeWithoutResponse)
        }

        discoverCompletion?(writeCharacteristic != nil)
        discoverCompletion = nil
    }

    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        writeCompletion?(error == nil)
    }
}
