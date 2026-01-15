package com.ihp.pos

import android.Manifest
import android.bluetooth.*
import android.bluetooth.le.*
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import java.util.*

class BlePrintPlugin(
    private val context: Context,
    private val flutterEngine: FlutterEngine
) : MethodChannel.MethodCallHandler {

    companion object {
        private const val CHANNEL = "ble_print_service"
        private const val CHUNK_SIZE = 512 // Max bytes per write
        private const val WRITE_DELAY = 50L // ms delay between chunks
    }

    private val bluetoothManager: BluetoothManager =
        context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager

    private val bluetoothAdapter: BluetoothAdapter? = bluetoothManager.adapter
    private val bluetoothLeScanner: BluetoothLeScanner? = bluetoothAdapter?.bluetoothLeScanner

    private var bluetoothGatt: BluetoothGatt? = null
    private var writeCharacteristic: BluetoothGattCharacteristic? = null
    private val scanResults = mutableListOf<ScanResult>()
    private var isScanning = false
    private var currentScanCallback: ScanCallback? = null

    private val mainHandler = Handler(Looper.getMainLooper())
    private val scope = CoroutineScope(Dispatchers.Main + SupervisorJob())

    init {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "send" -> {
                val deviceId = call.argument<String>("deviceId")
                val data = call.argument<ByteArray>("data")
                val serviceUuid = call.argument<String>("serviceUuid")
                val writeCharUuid = call.argument<String>("writeCharUuid")

                if (deviceId == null || data == null || serviceUuid == null || writeCharUuid == null) {
                    result.error("INVALID_ARGS", "Missing required arguments", null)
                    return
                }

                sendData(deviceId, data, serviceUuid, writeCharUuid, result)
            }
            "scanDevices" -> {
                val duration = call.argument<Int>("duration") ?: 5000
                scanDevices(duration.toLong(), result)
            }
            "stopScan" -> {
                stopScan()
                result.success(true)
            }
            "isBluetoothEnabled" -> {
                result.success(bluetoothAdapter?.isEnabled ?: false)
            }
            "enableBluetooth" -> {
                // Note: Requires runtime permission
                result.success(bluetoothAdapter?.isEnabled ?: false)
            }
            "connect" -> {
                val deviceId = call.argument<String>("deviceId")
                if (deviceId == null) {
                    result.error("INVALID_ARGS", "Device ID is null", null)
                    return
                }
                connectDevice(deviceId, result)
            }
            "disconnect" -> {
                disconnectDevice(result)
            }
            "isConnected" -> {
                result.success(bluetoothGatt != null)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun sendData(
        deviceId: String,
        data: ByteArray,
        serviceUuidStr: String,
        writeCharUuidStr: String,
        result: MethodChannel.Result
    ) {
        scope.launch {
            try {
                android.util.Log.d("BlePrint", "=== sendData started ===")
                android.util.Log.d("BlePrint", "Device ID: $deviceId")

                // 1. Connect
                val connected = connectDeviceSuspend(deviceId)
                if (!connected) {
                    android.util.Log.e("BlePrint", "Failed to connect")
                    result.error("CONNECTION_ERROR", "Failed to connect to device", null)
                    return@launch
                }
                android.util.Log.d("BlePrint", "Connected successfully")

                // 2. Discover services
                val discovered = discoverServicesSuspend()
                if (!discovered) {
                    android.util.Log.e("BlePrint", "Failed to discover services")
                    disconnectDevice(null)
                    result.error("DISCOVERY_ERROR", "Failed to discover services", null)
                    return@launch
                }
                android.util.Log.d("BlePrint", "Services discovered")

                // 3. Find write characteristic (auto-discover like iOS)
                writeCharacteristic = findWriteCharacteristic()

                // Fallback: try specific UUID if auto-discover fails
                if (writeCharacteristic == null) {
                    android.util.Log.d("BlePrint", "Auto-discover failed, trying specific UUID...")
                    try {
                        val serviceUuid = UUID.fromString(serviceUuidStr)
                        val charUuid = UUID.fromString(writeCharUuidStr)
                        val service = bluetoothGatt?.getService(serviceUuid)
                        writeCharacteristic = service?.getCharacteristic(charUuid)
                    } catch (e: Exception) {
                        android.util.Log.e("BlePrint", "UUID fallback failed: ${e.message}")
                    }
                }

                if (writeCharacteristic == null) {
                    android.util.Log.e("BlePrint", "No write characteristic found")
                    disconnectDevice(null)
                    result.error("CHAR_NOT_FOUND", "Write characteristic not found", null)
                    return@launch
                }
                android.util.Log.d("BlePrint", "Write characteristic found: ${writeCharacteristic?.uuid}")

                // 4. Write data in chunks
                val success = writeDataInChunks(data)
                android.util.Log.d("BlePrint", "Write result: $success")

                // 5. Disconnect
                delay(500) // Wait for last write
                disconnectDevice(null)

                result.success(success)
            } catch (e: Exception) {
                android.util.Log.e("BlePrint", "sendData error: ${e.message}")
                disconnectDevice(null)
                result.error("SEND_ERROR", "Error sending data: ${e.message}", null)
            }
        }
    }

    /**
     * Auto-discover write characteristic from all services (like iOS implementation)
     * This makes it compatible with different printer models that may have different UUIDs
     */
    private fun findWriteCharacteristic(): BluetoothGattCharacteristic? {
        val gatt = bluetoothGatt ?: return null

        android.util.Log.d("BlePrint", "=== Finding write characteristic ===")
        android.util.Log.d("BlePrint", "Total services: ${gatt.services?.size ?: 0}")

        // Loop through all services
        gatt.services?.forEach { service ->
            android.util.Log.d("BlePrint", "Service: ${service.uuid}")

            // Loop through all characteristics
            service.characteristics?.forEach { char ->
                val properties = char.properties
                val canWrite = (properties and BluetoothGattCharacteristic.PROPERTY_WRITE) != 0
                val canWriteNoResponse = (properties and BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE) != 0

                android.util.Log.d("BlePrint", "  Char: ${char.uuid}, Write=$canWrite, WriteNoResp=$canWriteNoResponse")

                // Return first characteristic that supports write
                if (canWrite || canWriteNoResponse) {
                    android.util.Log.d("BlePrint", "  → Selected this characteristic!")
                    return char
                }
            }
        }

        android.util.Log.d("BlePrint", "No write characteristic found in any service")
        return null
    }

    // Completion handlers for GATT operations
    private var connectContinuation: CancellableContinuation<Boolean>? = null
    private var discoverContinuation: CancellableContinuation<Boolean>? = null
    private var writeContinuation: CancellableContinuation<Boolean>? = null

    // Single unified GATT callback (more reliable than reflection swap)
    private val gattCallback = object : BluetoothGattCallback() {
        override fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
            android.util.Log.d("BlePrint", "onConnectionStateChange: status=$status, newState=$newState")
            when (newState) {
                BluetoothProfile.STATE_CONNECTED -> {
                    bluetoothGatt = gatt
                    connectContinuation?.resume(true) {}
                    connectContinuation = null
                }
                BluetoothProfile.STATE_DISCONNECTED -> {
                    connectContinuation?.resume(false) {}
                    connectContinuation = null
                }
            }
        }

        override fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {
            android.util.Log.d("BlePrint", "onServicesDiscovered: status=$status")
            discoverContinuation?.resume(status == BluetoothGatt.GATT_SUCCESS) {}
            discoverContinuation = null
        }

        override fun onCharacteristicWrite(
            gatt: BluetoothGatt,
            characteristic: BluetoothGattCharacteristic,
            status: Int
        ) {
            android.util.Log.d("BlePrint", "onCharacteristicWrite: status=$status")
            writeContinuation?.resume(status == BluetoothGatt.GATT_SUCCESS) {}
            writeContinuation = null
        }
    }

    private suspend fun connectDeviceSuspend(deviceId: String): Boolean =
        suspendCancellableCoroutine { continuation ->
            try {
                android.util.Log.d("BlePrint", "Connecting to device: $deviceId")
                val device = bluetoothAdapter?.getRemoteDevice(deviceId)
                if (device == null) {
                    android.util.Log.e("BlePrint", "Device not found: $deviceId")
                    continuation.resume(false) {}
                    return@suspendCancellableCoroutine
                }

                connectContinuation = continuation
                device.connectGatt(context, false, gattCallback)

                // Timeout after 10 seconds
                mainHandler.postDelayed({
                    if (connectContinuation != null) {
                        android.util.Log.e("BlePrint", "Connection timeout")
                        connectContinuation?.resume(false) {}
                        connectContinuation = null
                    }
                }, 10000)
            } catch (e: Exception) {
                android.util.Log.e("BlePrint", "Connect error: ${e.message}")
                continuation.resume(false) {}
            }
        }

    private suspend fun discoverServicesSuspend(): Boolean =
        suspendCancellableCoroutine { continuation ->
            val gatt = bluetoothGatt
            if (gatt == null) {
                android.util.Log.e("BlePrint", "GATT is null, cannot discover services")
                continuation.resume(false) {}
                return@suspendCancellableCoroutine
            }

            discoverContinuation = continuation
            val started = gatt.discoverServices()
            android.util.Log.d("BlePrint", "discoverServices started: $started")

            if (!started) {
                discoverContinuation = null
                continuation.resume(false) {}
            }

            // Timeout after 10 seconds
            mainHandler.postDelayed({
                if (discoverContinuation != null) {
                    android.util.Log.e("BlePrint", "Service discovery timeout")
                    discoverContinuation?.resume(false) {}
                    discoverContinuation = null
                }
            }, 10000)
        }

    private suspend fun writeDataInChunks(data: ByteArray): Boolean {
        val char = writeCharacteristic ?: return false
        val gatt = bluetoothGatt ?: return false

        // Split into chunks
        val chunks = data.toList().chunked(CHUNK_SIZE)

        for ((index, chunk) in chunks.withIndex()) {
            val success = writeChunkSuspend(gatt, char, chunk.toByteArray())
            if (!success) {
                return false
            }

            // Delay between chunks
            if (index < chunks.size - 1) {
                delay(WRITE_DELAY)
            }
        }

        return true
    }

    private suspend fun writeChunkSuspend(
        gatt: BluetoothGatt,
        char: BluetoothGattCharacteristic,
        chunk: ByteArray
    ): Boolean = suspendCancellableCoroutine { continuation ->
        writeContinuation = continuation

        char.value = chunk
        // Try WRITE_TYPE_DEFAULT first, fallback to NO_RESPONSE if needed
        char.writeType = if ((char.properties and BluetoothGattCharacteristic.PROPERTY_WRITE) != 0) {
            BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
        } else {
            BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE
        }

        val written = gatt.writeCharacteristic(char)
        android.util.Log.d("BlePrint", "writeCharacteristic: $written, chunk size: ${chunk.size}")

        if (!written) {
            writeContinuation = null
            continuation.resume(false) {}
        }

        // Timeout after 5 seconds
        mainHandler.postDelayed({
            if (writeContinuation != null) {
                android.util.Log.e("BlePrint", "Write timeout")
                writeContinuation?.resume(false) {}
                writeContinuation = null
            }
        }, 5000)
    }

    private fun scanDevices(durationMs: Long, result: MethodChannel.Result) {
        android.util.Log.d("BlePrint", "=== scanDevices called, duration=${durationMs}ms ===")

        if (isScanning) {
            android.util.Log.w("BlePrint", "Scan already in progress")
            result.error("ALREADY_SCANNING", "Scan already in progress", null)
            return
        }

        // Check permissions
        val hasPermission = checkBluetoothPermissions()
        if (!hasPermission) {
            android.util.Log.e("BlePrint", "Missing Bluetooth permissions")
            result.error("PERMISSION_DENIED", "Bluetooth permissions not granted. Please enable Bluetooth permissions in Settings.", null)
            return
        }

        // Check Bluetooth adapter
        if (bluetoothAdapter == null || !bluetoothAdapter.isEnabled) {
            android.util.Log.e("BlePrint", "Bluetooth adapter null or disabled")
            result.error("BLUETOOTH_OFF", "Bluetooth is not available or not enabled", null)
            return
        }

        // Check BLE scanner
        if (bluetoothLeScanner == null) {
            android.util.Log.e("BlePrint", "BLE scanner is null")
            result.error("BLE_NOT_AVAILABLE", "BLE scanner is not available", null)
            return
        }

        android.util.Log.d("BlePrint", "All checks passed, starting scan...")

        scanResults.clear()
        isScanning = true

        currentScanCallback = object : ScanCallback() {
            override fun onScanResult(callbackType: Int, scanResult: ScanResult) {
                if (!scanResults.any { it.device.address == scanResult.device.address }) {
                    scanResults.add(scanResult)
                    android.util.Log.d("BlePrint", "Found device: ${scanResult.device.name ?: "Unknown"} (${scanResult.device.address})")
                }
            }

            override fun onScanFailed(errorCode: Int) {
                android.util.Log.e("BlePrint", "Scan failed with error code: $errorCode")
                isScanning = false
                val errorMsg = when (errorCode) {
                    ScanCallback.SCAN_FAILED_ALREADY_STARTED -> "Scan already started"
                    ScanCallback.SCAN_FAILED_APPLICATION_REGISTRATION_FAILED -> "App registration failed"
                    ScanCallback.SCAN_FAILED_FEATURE_UNSUPPORTED -> "BLE scan not supported"
                    ScanCallback.SCAN_FAILED_INTERNAL_ERROR -> "Internal error"
                    else -> "Scan failed with code: $errorCode"
                }
                result.error("SCAN_FAILED", errorMsg, null)
            }
        }

        try {
            bluetoothLeScanner.startScan(currentScanCallback)
            android.util.Log.d("BlePrint", "BLE scan started for ${durationMs}ms")

            // Stop scan after duration
            mainHandler.postDelayed({
                stopScan()

                val devices = scanResults.map { scanResult ->
                    mapOf(
                        "name" to (scanResult.device.name ?: "Unknown"),
                        "id" to scanResult.device.address
                    )
                }

                android.util.Log.d("BlePrint", "Scan completed. Found ${devices.size} devices")
                result.success(devices)
            }, durationMs)
        } catch (e: SecurityException) {
            isScanning = false
            android.util.Log.e("BlePrint", "Permission denied: ${e.message}")
            result.error("PERMISSION_DENIED", "Bluetooth permission denied. Please grant BLUETOOTH_SCAN permission.", null)
        } catch (e: Exception) {
            isScanning = false
            android.util.Log.e("BlePrint", "Scan error: ${e.message}")
            result.error("SCAN_ERROR", "Failed to start scan: ${e.message}", null)
        }
    }

    private fun checkBluetoothPermissions(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Android 12+ (API 31+)
            val hasScan = ContextCompat.checkSelfPermission(
                context,
                Manifest.permission.BLUETOOTH_SCAN
            ) == PackageManager.PERMISSION_GRANTED

            val hasConnect = ContextCompat.checkSelfPermission(
                context,
                Manifest.permission.BLUETOOTH_CONNECT
            ) == PackageManager.PERMISSION_GRANTED

            android.util.Log.d("BlePrint", "Permission check (Android 12+): SCAN=$hasScan, CONNECT=$hasConnect")
            hasScan && hasConnect
        } else {
            // Android < 12
            val hasLocation = ContextCompat.checkSelfPermission(
                context,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED

            android.util.Log.d("BlePrint", "Permission check (Android <12): LOCATION=$hasLocation")
            hasLocation
        }
    }

    private fun stopScan() {
        if (isScanning) {
            currentScanCallback?.let { bluetoothLeScanner?.stopScan(it) }
            currentScanCallback = null
            isScanning = false
        }
    }

    private fun connectDevice(deviceId: String, result: MethodChannel.Result) {
        scope.launch {
            val connected = connectDeviceSuspend(deviceId)
            result.success(connected)
        }
    }

    private fun disconnectDevice(result: MethodChannel.Result?) {
        bluetoothGatt?.disconnect()
        bluetoothGatt?.close()
        bluetoothGatt = null
        writeCharacteristic = null
        result?.success(true)
    }

    fun cleanup() {
        scope.cancel()
        disconnectDevice(null)
        stopScan()
    }
}
