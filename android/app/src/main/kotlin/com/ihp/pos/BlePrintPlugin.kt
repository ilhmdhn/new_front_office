package com.ihp.pos

import android.Manifest
import android.bluetooth.*
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
import java.io.OutputStream
import java.util.*

/**
 * Android: Bluetooth Classic (SPP) for thermal printer
 * More reliable than BLE for most thermal printers
 *
 * iOS uses BLE (handled separately in BlePrintPlugin.swift)
 */
class BlePrintPlugin(
    private val context: Context,
    private val flutterEngine: FlutterEngine
) : MethodChannel.MethodCallHandler {

    companion object {
        private const val CHANNEL = "ble_print_service"
        private const val TAG = "BlePrint"

        // Standard SPP UUID for serial port communication
        private const val SPP_UUID = "00001101-0000-1000-8000-00805F9B34FB"

        private const val CHUNK_SIZE = 512
        private const val WRITE_DELAY = 30L // ms
    }

    private val bluetoothManager: BluetoothManager =
        context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager

    private val bluetoothAdapter: BluetoothAdapter? = bluetoothManager.adapter

    private var bluetoothSocket: BluetoothSocket? = null
    private var outputStream: OutputStream? = null

    private val mainHandler = Handler(Looper.getMainLooper())
    private val scope = CoroutineScope(Dispatchers.IO + SupervisorJob())

    init {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "send" -> {
                val deviceId = call.argument<String>("deviceId")
                val data = call.argument<ByteArray>("data")

                if (deviceId == null || data == null) {
                    result.error("INVALID_ARGS", "Missing required arguments", null)
                    return
                }

                sendData(deviceId, data, result)
            }
            "scanDevices" -> {
                scanDevices(result)
            }
            "stopScan" -> {
                // No-op for Classic, scan is instant
                result.success(true)
            }
            "isBluetoothEnabled" -> {
                result.success(bluetoothAdapter?.isEnabled ?: false)
            }
            "enableBluetooth" -> {
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
                result.success(bluetoothSocket?.isConnected ?: false)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    /**
     * Send data via Bluetooth Classic (SPP)
     * Flow: Connect → Write → Disconnect
     */
    private fun sendData(deviceId: String, data: ByteArray, result: MethodChannel.Result) {
        scope.launch {
            try {
                android.util.Log.d(TAG, "=== sendData (Classic SPP) ===")
                android.util.Log.d(TAG, "Device: $deviceId, Data size: ${data.size} bytes")

                // 1. Connect
                val connected = connectDeviceInternal(deviceId)
                if (!connected) {
                    mainHandler.post {
                        result.error("CONNECTION_ERROR", "Failed to connect to printer", null)
                    }
                    return@launch
                }
                android.util.Log.d(TAG, "Connected successfully")

                // 2. Write data in chunks
                val success = writeDataInChunks(data)
                android.util.Log.d(TAG, "Write result: $success")

                // 3. Disconnect
                delay(300)
                disconnectInternal()

                mainHandler.post {
                    result.success(success)
                }
            } catch (e: Exception) {
                android.util.Log.e(TAG, "sendData error: ${e.message}")
                disconnectInternal()
                mainHandler.post {
                    result.error("SEND_ERROR", "Error: ${e.message}", null)
                }
            }
        }
    }

    /**
     * Connect to device via Bluetooth Classic SPP
     */
    private fun connectDeviceInternal(deviceId: String): Boolean {
        try {
            // Check permission
            if (!hasBluetoothConnectPermission()) {
                android.util.Log.e(TAG, "Missing BLUETOOTH_CONNECT permission")
                return false
            }

            val device = bluetoothAdapter?.getRemoteDevice(deviceId)
            if (device == null) {
                android.util.Log.e(TAG, "Device not found: $deviceId")
                return false
            }

            android.util.Log.d(TAG, "Connecting to ${device.name} ($deviceId)")

            // Cancel discovery to speed up connection
            bluetoothAdapter?.cancelDiscovery()

            // Create socket with SPP UUID
            val uuid = UUID.fromString(SPP_UUID)
            bluetoothSocket = device.createRfcommSocketToServiceRecord(uuid)

            // Connect (blocking call)
            bluetoothSocket?.connect()
            outputStream = bluetoothSocket?.outputStream

            android.util.Log.d(TAG, "Socket connected: ${bluetoothSocket?.isConnected}")
            return bluetoothSocket?.isConnected ?: false

        } catch (e: Exception) {
            android.util.Log.e(TAG, "Connect error: ${e.message}")

            // Try fallback method for some devices
            try {
                android.util.Log.d(TAG, "Trying fallback connection method...")
                val device = bluetoothAdapter?.getRemoteDevice(deviceId)
                val method = device?.javaClass?.getMethod("createRfcommSocket", Int::class.javaPrimitiveType)
                bluetoothSocket = method?.invoke(device, 1) as? BluetoothSocket
                bluetoothSocket?.connect()
                outputStream = bluetoothSocket?.outputStream

                android.util.Log.d(TAG, "Fallback connected: ${bluetoothSocket?.isConnected}")
                return bluetoothSocket?.isConnected ?: false
            } catch (e2: Exception) {
                android.util.Log.e(TAG, "Fallback also failed: ${e2.message}")
                return false
            }
        }
    }

    /**
     * Write data in chunks to prevent buffer overflow
     */
    private suspend fun writeDataInChunks(data: ByteArray): Boolean {
        val stream = outputStream ?: return false

        try {
            val chunks = data.toList().chunked(CHUNK_SIZE)
            android.util.Log.d(TAG, "Writing ${chunks.size} chunks...")

            for ((index, chunk) in chunks.withIndex()) {
                stream.write(chunk.toByteArray())
                stream.flush()

                // Small delay between chunks
                if (index < chunks.size - 1) {
                    delay(WRITE_DELAY)
                }
            }

            android.util.Log.d(TAG, "All chunks written successfully")
            return true
        } catch (e: Exception) {
            android.util.Log.e(TAG, "Write error: ${e.message}")
            return false
        }
    }

    /**
     * Disconnect socket
     */
    private fun disconnectInternal() {
        try {
            outputStream?.close()
            bluetoothSocket?.close()
        } catch (e: Exception) {
            android.util.Log.e(TAG, "Disconnect error: ${e.message}")
        }
        outputStream = null
        bluetoothSocket = null
    }

    /**
     * Get list of bonded (paired) Bluetooth devices
     * This is instant, no scanning needed for Classic Bluetooth
     */
    private fun scanDevices(result: MethodChannel.Result) {
        android.util.Log.d(TAG, "=== Getting bonded devices (Classic) ===")

        if (!hasBluetoothConnectPermission()) {
            result.error("PERMISSION_DENIED", "Bluetooth permission not granted", null)
            return
        }

        if (bluetoothAdapter == null || !bluetoothAdapter.isEnabled) {
            result.error("BLUETOOTH_OFF", "Bluetooth is not enabled", null)
            return
        }

        try {
            val bondedDevices = bluetoothAdapter.bondedDevices
            val devices = bondedDevices?.map { device ->
                mapOf(
                    "name" to (device.name ?: "Unknown"),
                    "id" to device.address
                )
            } ?: emptyList()

            android.util.Log.d(TAG, "Found ${devices.size} bonded devices")
            devices.forEach {
                android.util.Log.d(TAG, "  - ${it["name"]} (${it["id"]})")
            }

            result.success(devices)
        } catch (e: SecurityException) {
            android.util.Log.e(TAG, "Permission error: ${e.message}")
            result.error("PERMISSION_DENIED", "Bluetooth permission denied", null)
        } catch (e: Exception) {
            android.util.Log.e(TAG, "Scan error: ${e.message}")
            result.error("SCAN_ERROR", "Failed to get devices: ${e.message}", null)
        }
    }

    private fun connectDevice(deviceId: String, result: MethodChannel.Result) {
        scope.launch {
            val connected = connectDeviceInternal(deviceId)
            mainHandler.post {
                result.success(connected)
            }
        }
    }

    private fun disconnectDevice(result: MethodChannel.Result?) {
        disconnectInternal()
        result?.success(true)
    }

    private fun hasBluetoothConnectPermission(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            ContextCompat.checkSelfPermission(
                context,
                Manifest.permission.BLUETOOTH_CONNECT
            ) == PackageManager.PERMISSION_GRANTED
        } else {
            true // Permission not needed below Android 12
        }
    }

    fun cleanup() {
        scope.cancel()
        disconnectInternal()
    }
}
