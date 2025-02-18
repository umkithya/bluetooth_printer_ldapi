import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bluetooth_printer_ldapi_method_channel.dart';
import 'model/printer_info_model.dart';

abstract class BluetoothPrinterLdapiPlatform extends PlatformInterface {
  static final Object _token = Object();

  static BluetoothPrinterLdapiPlatform _instance =
      MethodChannelBluetoothPrinterLdapi();

  /// The default instance of [BluetoothPrinterLdapiPlatform] to use.
  ///
  /// Defaults to [MethodChannelBluetoothPrinterLdapi].
  static BluetoothPrinterLdapiPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BluetoothPrinterLdapiPlatform] when
  /// they register themselves.
  static set instance(BluetoothPrinterLdapiPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Constructs a BluetoothPrinterLdapiPlatform.
  BluetoothPrinterLdapiPlatform() : super(token: _token);

  Future<void> closePrinter() {
    // TODO: implement closePrinter
    throw UnimplementedError();
  }

  Future<void> closePrinterAndroid() {
    // TODO: implement startDraw
    throw UnimplementedError();
  }

  Future<PrinterInfoIos> connectingPrinterDetailInfos() async {
    throw UnimplementedError();
  }

  Future<String> connnectPrinterAndroid(PrinterInfoAndroid printer) {
    // TODO: implement startDraw
    throw UnimplementedError();
  }

  Future<bool> drawBarcode(
      String text, double x, double y, double width, double height) {
    // TODO: implement drawBarcode
    throw UnimplementedError();
  }

  Future<bool> drawImage(String fileUrl, double x, double y, double width,
      double height, int threshold) {
    // TODO: implement drawText
    throw UnimplementedError();
  }

  Future<bool> drawImageWithImage(Uint8List image, double x, double y,
      double width, double height, int threshold) {
    // TODO: implement drawImageWithImage
    throw UnimplementedError();
  }

  Future<bool> drawQRCode(String text, double x, double y, double width) {
    // TODO: implement drawQRCode
    throw UnimplementedError();
  }

  Future<bool> drawText(String text, double x, double y, double width,
      double height, double fontHeight) {
    // TODO: implement drawText
    throw UnimplementedError();
  }

  Future<void> endDraw() {
    // TODO: implement endDraw
    throw UnimplementedError();
  }

  Future<void> initPrinterAndroid() async {
    throw UnimplementedError();
  }

  Future<bool> openPrinter(String printerName) {
    // TODO: implement openPrinter
    throw UnimplementedError();
  }

  Future<void> print(Function(bool) callback) {
    // TODO: implement print
    throw UnimplementedError();
  }

  Future<String> printImageAndroid(Uint8List image,
      {bool isOrientation = false}) {
    // TODO: implement startDraw
    throw UnimplementedError();
  }

  Future<List<PrinterInfoAndroid>> scanPrinterForAndroid() async {
    throw UnimplementedError();
  }

  Future<List<String>> scanPrinters() {
    // TODO: implement scanPrinters
    throw UnimplementedError();
  }

  Future<void> setPrintDarkness(int darkness) {
    // TODO: implement setPrintDarkness
    throw UnimplementedError();
  }

  Future<void> setPrintPageGapLength(int gapLength) {
    // TODO: implement setPrintPageGapLength
    throw UnimplementedError();
  }

  Future<void> setPrintPageGapType(int gapType) {
    // TODO: implement setPrintPageGapType
    throw UnimplementedError();
  }

  Future<void> setPrintSpeed(int speed) {
    // TODO: implement setPrintSpeed
    throw UnimplementedError();
  }

  Future<bool> startDraw(double width, double height, int orientation) {
    // TODO: implement startDraw
    throw UnimplementedError();
  }
}
