import 'package:bluetooth_printer_ldapi/model/printer_info_model.dart';

import 'bluetooth_printer_ldapi_platform_interface.dart';

class BluetoothPrinterLdapi implements BluetoothPrinterLdapiPlatform {
  @override
  Future<void> closePrinter() async {
    await BluetoothPrinterLdapiPlatform.instance.closePrinter();
  }

  @override
  Future<bool> drawBarcode(
      String text, double x, double y, double width, double height) {
    return BluetoothPrinterLdapiPlatform.instance
        .drawBarcode(text, x, y, width, height);
  }

  @override
  Future<bool> drawQRCode(String text, double x, double y, double width) {
    return BluetoothPrinterLdapiPlatform.instance.drawQRCode(text, x, y, width);
  }

  @override
  Future<bool> drawText(String text, double x, double y, double width,
      double height, double fontHeight) {
    return BluetoothPrinterLdapiPlatform.instance
        .drawText(text, x, y, width, height, fontHeight);
  }

  @override
  Future<void> endDraw() async {
    await BluetoothPrinterLdapiPlatform.instance.endDraw();
  }

  @override
  Future<bool> openPrinter(String printerName) {
    return BluetoothPrinterLdapiPlatform.instance.openPrinter(printerName);
  }

  @override
  Future<void> print(dynamic Function(bool) callback) async {
    await BluetoothPrinterLdapiPlatform.instance.print(callback);
  }

  @override
  Future<List<String>> scanPrinters() {
    return BluetoothPrinterLdapiPlatform.instance.scanPrinters();
  }

  @override
  Future<void> setPrintDarkness(int darkness) async {
    await BluetoothPrinterLdapiPlatform.instance.setPrintDarkness(darkness);
  }

  @override
  Future<void> setPrintPageGapLength(int gapLength) async {
    BluetoothPrinterLdapiPlatform.instance.setPrintPageGapLength(gapLength);
  }

  @override
  Future<void> setPrintPageGapType(int gapType) async {
    await BluetoothPrinterLdapiPlatform.instance.setPrintPageGapType(gapType);
  }

  @override
  Future<void> setPrintSpeed(int speed) async {
    await BluetoothPrinterLdapiPlatform.instance.setPrintSpeed(speed);
  }

  @override
  Future<bool> startDraw(double width, double height, int orientation) {
    return BluetoothPrinterLdapiPlatform.instance
        .startDraw(width, height, orientation);
  }
  
  @override
  Future<bool> drawImage(String fileUrl, double x, double y, double width, double height, int threshold) {
   return BluetoothPrinterLdapiPlatform.instance
        .drawImage(fileUrl,x,y,width,height,threshold);
  }

  @override
  Future<PrinterInfo> connectingPrinterDetailInfos() {
    return BluetoothPrinterLdapiPlatform.instance.connectingPrinterDetailInfos();
  }
}
