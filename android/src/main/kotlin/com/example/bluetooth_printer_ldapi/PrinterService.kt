package com.example.bluetooth_printer_ldapi

import android.Manifest
import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.os.Build
import android.os.Handler
import android.text.TextUtils
import com.dothantech.lpapi.LPAPI
import com.dothantech.printer.IDzPrinter.PrinterAddress
import androidx.core.app.ActivityCompat
import com.dothantech.printer.IDzPrinter
import com.dothantech.printer.IDzPrinter.PrintData
import com.dothantech.printer.IDzPrinter.PrintProgress
import com.dothantech.printer.IDzPrinter.ProgressInfo
import android.graphics.Bitmap
import android.os.Bundle

sealed class PrinterResult<out T> {
    data class Success<out T>(val data: T) : PrinterResult<T>()
    data class Error(val message: String) : PrinterResult<Nothing>()
}
class PrinterService(private val activity: Activity) {
        private var api: LPAPI? = null
        private var pairedPrinters: List<PrinterAddress> = ArrayList()
        private val mHandler = Handler()
        //Print parameters
        private var gapType = -1
        private var gapLength = 3
        private var printDensity = -1
        private var printSpeed = -1
        private val bitmapOrientations = intArrayOf(0, 90, 0, 90)
        fun init(){
            // Call the init method of the LPAPI object to initialize the object
            this.api = LPAPI.Factory.createInstance(mCallback)
            requestPermission()
        }
        fun close(){
            // Call the init method of the LPAPI object to initialize the object
            api!!.quit()
        }
        private val mCallback: LPAPI.Callback = object : LPAPI.Callback {
            //****************************************************************************************************************************************
            // All callback functions are called in the printing thread, so if you need to refresh the interface, you need to send a message to the main thread of the interface to avoid cumbersome operations such as mutual exclusion.
            //****************************************************************************************************************************************
            // Called when the printer connection status changes
            override fun onStateChange(arg0: PrinterAddress, arg1: IDzPrinter.PrinterState) {
                val printer = arg0
                when (arg1) {
                    IDzPrinter.PrinterState.Connected, IDzPrinter.PrinterState.Connected2 ->                     // The printer is connected successfully, a notification is sent, and the interface prompt is refreshed.
                        mHandler.post {
                            println("## connected successfully")
                        }

                    IDzPrinter.PrinterState.Disconnected ->                     // Printer connection fails, disconnects, sends notification, refreshes interface prompts
                        mHandler.post {  println("## connection fails, disconnects") }

                    else -> {}
                }
            }

            // Called when the status of the Bluetooth adapter changes
            override fun onProgressInfo(arg0: ProgressInfo, arg1: Any) {
            }

            override fun onPrinterDiscovery(printerAddress: PrinterAddress, o: Any) {
            }

            // It is called when the progress of printing labels changes.
            override fun onPrintProgress(
                    address: PrinterAddress,
                    bitmapData: PrintData,
                    progress: PrintProgress,
                    addiInfo: Any
                ) {
                    when (progress) {
                        PrintProgress.Success ->                     // The label is printed successfully, a notification is sent, and the interface prompt is refreshed.
                            mHandler.post { println("## printed successfully") }

                        PrintProgress.Failed ->                     // Failed to print labels, send notification, refresh interface prompt
                            mHandler.post { println("Failed to print") }

                        else -> {}
                    }
                }
        }
        private fun requestPermission() {
                // Request permissions
                val permissions: Array<String> = if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) { // Use Build.VERSION_CODES.S for Android 12 (API 31)
                    arrayOf(
                        Manifest.permission.BLUETOOTH,
                        Manifest.permission.ACCESS_FINE_LOCATION,
                        Manifest.permission.ACCESS_COARSE_LOCATION
                    )
                } else {
                    arrayOf(
                        Manifest.permission.BLUETOOTH_SCAN,
                        Manifest.permission.BLUETOOTH_CONNECT,
                        Manifest.permission.BLUETOOTH,
                        Manifest.permission.ACCESS_FINE_LOCATION,
                        Manifest.permission.ACCESS_COARSE_LOCATION
                    )
                }

                // Ensure this function is called from an Activity or Fragment
                ActivityCompat.requestPermissions(activity,permissions, 0)
        }
        fun scanPrinter() :PrinterResult <List<Map<String, Any?>>> {
                val btAdapter = BluetoothAdapter.getDefaultAdapter()
                if (btAdapter == null) {
                    return  PrinterResult.Error("Current device does not support Bluetooth!")
                }
                if (!btAdapter.isEnabled) {
                    return  PrinterResult.Error("Bluetooth adapter is not enabled!")
                }

                pairedPrinters = api!!.getAllPrinterAddresses(null)
            // Convert PrinterAddress objects to a list of Maps
            val printerList = pairedPrinters.map { printer ->
                mapOf(
                    "macAddress" to printer.macAddress,
                    "shownName" to printer.shownName,
                    "addressType" to printer.addressType.toString()
                )
            }
//                AlertDialog.Builder(this@MainActivity)
//                    .setTitle("Select a paired device")
//                    .setAdapter(DeviceListAdapter(this@MainActivity, pairedPrinters), DeviceListItemClicker())
//                    .show()
            return PrinterResult.Success(printerList)
        }
        private fun printBitmap(bitmap: Bitmap, param: Bundle): Boolean {
            // Print the image
            return api!!.printBitmap(bitmap, param)
        }

        private fun getPrintParam(copies: Int, orientation: Int): Bundle {
            val param = Bundle()

            // Gap type
            if (gapType >= 0) {
                param.putInt(IDzPrinter.PrintParamName.GAP_TYPE, gapType)
            }
            // Gap length
            if (gapLength >= 0) {
                param.putInt(IDzPrinter.PrintParamName.GAP_LENGTH, gapLength)
            }
            // Print density
            if (printDensity >= 0) {
                param.putInt(IDzPrinter.PrintParamName.PRINT_DENSITY, printDensity)
            }
            // Print speed
            if (printSpeed >= 0) {
                param.putInt(IDzPrinter.PrintParamName.PRINT_SPEED, printSpeed)
            }
            // Print page rotation angle
            if (orientation != 0) {
                param.putInt(IDzPrinter.PrintParamName.PRINT_DIRECTION, orientation)
            }
            // Number of copies
            if (copies > 1) {
                param.putInt(IDzPrinter.PrintParamName.PRINT_COPIES, copies)
            }
            return param
        }
        fun printPicture(bitmap: Bitmap,isOrientation:Boolean=false):PrinterResult<String>{

            if (isPrinterConnected) {
                var orientation = 0
                orientation = if(isOrientation){
                    1
                }else{
                    0
                }
//                if (bitmapOrientations.size > which) {
//                    orientation = bitmapOrientations[which]
//                }

                // Get print data and print
                val bmp = bitmap
                if (bmp != null) {
                    if (printBitmap(bmp, getPrintParam(1, orientation))) {

                        return PrinterResult.Success("Printing label...")
                    }
                }
                return PrinterResult.Error("Label printing failed!")

            }
            return PrinterResult.Error("Printer has not been connected yet!")
        }
        private val isPrinterConnected: Boolean
            // Check whether the printer is currently connected
            get() {
                // Call the getPrinterState method of the LPAPI object to get the current printer connection status
                val state = api!!.printerState

                // Printer is not connected
                if (state == null || state == IDzPrinter.PrinterState.Disconnected) {

                    return false
                }

                // Printer is connecting
                if (state == IDzPrinter.PrinterState.Connecting) {

                    return false
                }

                // Printer is connected
                return true
            }
        fun  connectToPrinter( printer:PrinterAddress):PrinterResult<String>{
//            Connect to the selected printer
            if (printer != null) {
                // Connect to the selected printer
                if (api!!.openPrinterByAddress(printer)) {
                    // Successfully submitted the request to connect to the printer, update the UI
                    return PrinterResult.Success(onPrinterConnecting(printer))

                }
            }
            // Failed to connect to the printer, update the UI
            return PrinterResult.Error(onPrinterDisconnected())
        }
        private fun onPrinterConnecting(printer: PrinterAddress):String {
            // Refresh UI prompt when a printer connection request is successfully submitted
            var txt = printer.shownName
            if (TextUtils.isEmpty(txt)) {
                txt = printer.macAddress
            }
            txt = String.format("Connecting to printer [%s]", txt)
            return txt
        }

        private fun onPrinterDisconnected():String {


            // Restore previously set printer parameters to default values after the printer disconnects
            gapType = -1
            gapLength = 3
            printDensity = -1
            printSpeed = -1
//            refreshPrintParamView()
            return "Printer connection failed!"
        }

        fun subtract(a: Int, b: Int): Int {
            return a - b
        }

}


