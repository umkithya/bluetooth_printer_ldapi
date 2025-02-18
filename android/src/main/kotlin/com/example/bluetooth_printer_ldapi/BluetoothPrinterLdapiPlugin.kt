package com.example.bluetooth_printer_ldapi

import android.app.Activity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import com.dothantech.printer.IDzPrinter
import com.dothantech.printer.IDzPrinter.PrinterAddress


/** BluetoothPrinterLdapiPlugin */
class BluetoothPrinterLdapiPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel: MethodChannel
  private var printerService: PrinterService? = null
  private var activity: Activity? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "bluetooth_printer_ldapi")
    channel.setMethodCallHandler(this)
    // Do not initialize PrinterService here, as activity is not available yet
  }
    private fun byteArrayToBitmap(byteArray: ByteArray): Bitmap? {
        return BitmapFactory.decodeByteArray(byteArray, 0, byteArray.size)
    }
  override fun onMethodCall(call: MethodCall, result: Result) {

      when (call.method) {
        "init" -> {
          if (activity != null) {
            if(printerService ==null){
                result.error("PrinterService", "PrinterService is null", null)
            }
            printerService?.init()
            result.success("PrinterService initialized")
          }else{
            result.error("ACTIVITY_ERROR", "activity is null", null)
          }
        }
        "close" -> {
          if (activity != null) {
            printerService?.close()
            result.success("PrinterService closed")
          }else{
            result.error("ACTIVITY_ERROR", "activity is null", null)
          }
        }
        "scanPrinter" -> {
          if (activity != null) {
                val scanResult = printerService?.scanPrinter()
                when (scanResult) {
                    is PrinterResult.Success -> result.success(scanResult.data)
                    is PrinterResult.Error -> result.error("SCAN_ERROR", scanResult.message, null)
                  null -> result.error("SCAN_ERROR", "Unknown Error", null)
                }
          }else{
            result.error("ACTIVITY_ERROR", "activity is null", null)
          }
        }
        "connectToPrinter" -> {
          if (activity != null) {
            val printerAddress = call.arguments as? Map<*, *>
            if (printerAddress != null) {
                val macAddress = printerAddress["macAddress"] as? String
                val shownName = printerAddress["shownName"] as? String
                val addressType = when (printerAddress["addressType"] as? String) {
                    "Bluetooth" -> IDzPrinter.AddressType.BLE
                    "USB" -> IDzPrinter.AddressType.USB
                    "WiFi" -> IDzPrinter.AddressType.WiFi
                    "DUAL" -> IDzPrinter.AddressType.DUAL
                    else -> null
                }

                if (macAddress != null && addressType != null) {
                    val printer = PrinterAddress(shownName, macAddress, addressType)
                    val connectResult = printerService?.connectToPrinter(printer)
                    when (connectResult) {
                        is PrinterResult.Success -> result.success(connectResult.data)
                        is PrinterResult.Error -> result.error("CONNECT_ERROR", connectResult.message, null)
                        null -> result.error("SCAN_ERROR", "Unknown Error", null)
                    }
                } else {
                    result.error("INVALID_ARGUMENT", "Invalid printer details", null)
                }
            } else {
                result.error("INVALID_ARGUMENT", "Printer address is null or invalid", null)
            }
            // val printerAddress = call.arguments as? Map<*, *>
            // if(printerAddress !=null){
            //   val address= PrinterAddress(

            //   )
            // }
            // val connectResult = printerService?.connectToPrinter(printerAddress)
            // when (connectResult) {
            //   is PrinterResult.Success -> result.success(connectResult.data)
            //   is PrinterResult.Error -> result.error("CONNECT_ERROR", connectResult.message, null)
            //   null -> result.error("CONNECT_ERROR", "Unknown Error", null)
            // }
          }else{
            result.error("ACTIVITY_ERROR", "activity is null", null)
          }
        }
        "printPicture" -> {
          if (activity != null) {

              val imageData = call.argument<ByteArray>("bitmap")
              val isOrientation = call.argument<Boolean>("isOrientation") ?: false
              if (imageData != null) {
                  val bitmap = byteArrayToBitmap(imageData)
                  if (bitmap != null) {
                      val printResult = printerService?.printPicture(bitmap, isOrientation)
                      when (printResult) {
                          is PrinterResult.Success -> result.success(printResult.data)
                          is PrinterResult.Error -> result.error("PRINT_ERROR", printResult.message, null)
                          null -> result.error("PRINT_ERROR", "Unknown Error", null)
                      }

                  } else {
                      result.error("BITMAP_ERROR", "Failed to create Bitmap", null)
                  }
              } else {
                  result.error("NULL_DATA", "No image data received", null)
              }


          }else{
            result.error("ACTIVITY_ERROR", "activity is null", null)
          }
        } else -> result.notImplemented()
      }


  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    // Initialize PrinterService only when activity is available
    printerService = PrinterService(activity!!)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
    printerService = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
    // Reinitialize PrinterService when activity is reattached
    printerService = PrinterService(activity!!)
  }

  override fun onDetachedFromActivity() {
    activity = null
    printerService = null
  }
}