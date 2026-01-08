package com.ihp.pos

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothSocket
import android.content.Intent
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.IOException
import java.io.OutputStream
import java.util.*

class BluetoothPrintPlugin(private val flutterEngine: FlutterEngine) : MethodChannel.MethodCallHandler {

    companion object {
        private const val CHANNEL = "bluetooth_print_service"
        private val SPP_UUID = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB")
    }

    private val bluetoothAdapter: BluetoothAdapter? = BluetoothAdapter.getDefaultAdapter()
    private var bluetoothSocket: BluetoothSocket? = null
    private var outputStream: OutputStream? = null
    private var currentDeviceAddress: String? = null

    init {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "send" -> {
                val address = call.argument<String>("address")
                val data = call.argument<ByteArray>("data")

                if (address == null || data == null) {
                    result.error("INVALID_ARGS", "Address or data is null", null)
                    return
                }

                sendData(address, data, result)
            }
            "connect" -> {
                val address = call.argument<String>("address")
                if (address == null) {
                    result.error("INVALID_ARGS", "Address is null", null)
                    return
                }

                connect(address, result)
            }
            "disconnect" -> {
                disconnect(result)
            }
            "isConnected" -> {
                val address = call.argument<String>("address")
                result.success(isConnected(address))
            }
            "scanDevices" -> {
                scanDevices(result)
            }
            "getPairedDevices" -> {
                getPairedDevices(result)
            }
            "isBluetoothEnabled" -> {
                result.success(bluetoothAdapter?.isEnabled ?: false)
            }
            "enableBluetooth" -> {
                enableBluetooth(result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun connect(address: String, result: MethodChannel.Result) {
        try {
            // Check if already connected to this device
            if (isConnected(address)) {
                result.success(true)
                return
            }

            // Disconnect from previous device if any
            disconnect(null)

            val device = bluetoothAdapter?.getRemoteDevice(address)
            if (device == null) {
                result.error("DEVICE_NOT_FOUND", "Device not found", null)
                return
            }

            bluetoothSocket = device.createRfcommSocketToServiceRecord(SPP_UUID)
            bluetoothAdapter?.cancelDiscovery()

            bluetoothSocket?.connect()
            outputStream = bluetoothSocket?.outputStream
            currentDeviceAddress = address

            result.success(true)
        } catch (e: IOException) {
            result.error("CONNECTION_ERROR", "Failed to connect: ${e.message}", null)
        } catch (e: Exception) {
            result.error("UNKNOWN_ERROR", "Unknown error: ${e.message}", null)
        }
    }

    private fun sendData(address: String, data: ByteArray, result: MethodChannel.Result) {
        try {
            // Auto-connect if not connected
            if (!isConnected(address)) {
                connect(address, object : MethodChannel.Result {
                    override fun success(connectResult: Any?) {
                        // Connection successful, proceed to send
                        performSend(data, result)
                    }
                    override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                        result.error(errorCode, errorMessage, errorDetails)
                    }
                    override fun notImplemented() {
                        result.notImplemented()
                    }
                })
            } else {
                performSend(data, result)
            }
        } catch (e: Exception) {
            result.error("SEND_ERROR", "Failed to send data: ${e.message}", null)
        }
    }

    private fun performSend(data: ByteArray, result: MethodChannel.Result) {
        try {
            outputStream?.write(data)
            outputStream?.flush()
            result.success(true)
        } catch (e: IOException) {
            result.error("WRITE_ERROR", "Failed to write data: ${e.message}", null)
        }
    }

    private fun disconnect(result: MethodChannel.Result?) {
        try {
            outputStream?.close()
            bluetoothSocket?.close()
            outputStream = null
            bluetoothSocket = null
            currentDeviceAddress = null
            result?.success(true)
        } catch (e: IOException) {
            result?.error("DISCONNECT_ERROR", "Failed to disconnect: ${e.message}", null)
        }
    }

    private fun isConnected(address: String?): Boolean {
        return bluetoothSocket?.isConnected == true && currentDeviceAddress == address
    }

    private fun scanDevices(result: MethodChannel.Result) {
        // Note: Scanning requires runtime permissions on Android 6.0+
        // For simplicity, return paired devices
        // Full implementation would use BroadcastReceiver for device discovery
        result.error("NOT_IMPLEMENTED", "Use getPairedDevices instead", null)
    }

    private fun getPairedDevices(result: MethodChannel.Result) {
        try {
            val pairedDevices = bluetoothAdapter?.bondedDevices
            val deviceList = mutableListOf<Map<String, String>>()

            pairedDevices?.forEach { device ->
                deviceList.add(mapOf(
                    "name" to (device.name ?: "Unknown"),
                    "address" to device.address
                ))
            }

            result.success(deviceList)
        } catch (e: Exception) {
            result.error("GET_DEVICES_ERROR", "Failed to get paired devices: ${e.message}", null)
        }
    }

    private fun enableBluetooth(result: MethodChannel.Result) {
        try {
            if (bluetoothAdapter?.isEnabled == false) {
                // Note: This requires activity context for startActivityForResult
                // Simplified version - just returns current state
                result.success(false)
            } else {
                result.success(true)
            }
        } catch (e: Exception) {
            result.error("ENABLE_ERROR", "Failed to enable bluetooth: ${e.message}", null)
        }
    }
}
