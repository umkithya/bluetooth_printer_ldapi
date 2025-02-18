import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'bluetooth_printer_ldapi_platform_interface.dart';
import 'model/printer_info_model.dart';

/// An implementation of [BluetoothPrinterLdapiPlatform] that uses method channels.
class MethodChannelBluetoothPrinterLdapi extends BluetoothPrinterLdapiPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final _channel = const MethodChannel('bluetooth_printer_ldapi');

  @override
  Future<void> closePrinter() async {
    await _channel.invokeMethod('closePrinter');
  }

  @override
  Future<String> closePrinterAndroid() async {
    return await _channel.invokeMethod('close');
  }

  @override
  Future<PrinterInfoIos> connectingPrinterDetailInfos() async {
    final Map<String, dynamic> result = Map<String, dynamic>.from(
        await _channel.invokeMethod('connectingPrinterDetailInfos'));
    return PrinterInfoIos.fromMap(result);
  }

  @override
  Future<String> connnectPrinterAndroid(PrinterInfoAndroid printer) async {
    return await _channel.invokeMethod('connectToPrinter', printer.toMap());
  }

  @override
  Future<bool> drawBarcode(
      String text, double x, double y, double width, double height) async {
    final bool result = await _channel.invokeMethod('drawBarcode', {
      'text': text,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
    });
    return result;
  }

  @override
  Future<bool> drawImage(String fileUrl, double x, double y, double width,
      double height, int threshold) async {
    final bool result = await _channel.invokeMethod('drawImage', {
      'file': fileUrl,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'threshold': threshold,
    });
    return result;
  }

  @override
  Future<bool> drawQRCode(String text, double x, double y, double width) async {
    final bool result = await _channel.invokeMethod('drawQRCode', {
      'text': text,
      'x': x,
      'y': y,
      'width': width,
    });
    return result;
  }

  @override
  Future<bool> drawText(String text, double x, double y, double width,
      double height, double fontHeight) async {
    final bool result = await _channel.invokeMethod('drawText', {
      'text': text,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'fontHeight': fontHeight,
    });
    return result;
  }

  @override
  Future<void> endDraw() async {
    await _channel.invokeMethod('endDraw');
  }

  @override
  Future<void> initPrinterAndroid() async {
    final result = await _channel.invokeMethod('init');
    debugPrint("initPrinterAndroid: $result");
  }

  @override
  Future<bool> openPrinter(String printerName) async {
    final bool result = await _channel
        .invokeMethod('openPrinter', {'printerName': printerName});
    return result;
  }

  @override
  Future<void> print(dynamic Function(bool) callback) async {
    final bool result = await _channel.invokeMethod('print');
    callback(result);
  }

  @override
  Future<String> printImageAndroid(Uint8List image,
      {bool isOrientation = false}) async {
    final result = await _channel.invokeMethod('printPicture', {
      'bitmap': image,
      'isOrientation': isOrientation,
    });
    return result;
  }

  @override
  Future<List<PrinterInfoAndroid>> scanPrinterForAndroid() async {
    final List<dynamic> printers = await _channel.invokeMethod('scanPrinter');
    if (printers.isNotEmpty) {
      return printers
          .map((printer) =>
              PrinterInfoAndroid.fromMap(Map<String, dynamic>.from(printer)))
          .toList();
    } else {
      return [];
    }
  }

  @override
  Future<List<String>> scanPrinters() async {
    final List<dynamic> result = await _channel.invokeMethod('scanPrinters');
    return result.cast<String>();
  }

  @override
  Future<void> setPrintDarkness(int darkness) async {
    await _channel.invokeMethod('setPrintDarkness', {'darkness': darkness});
  }

  @override
  Future<void> setPrintPageGapLength(int gapLength) async {
    await _channel
        .invokeMethod('setPrintPageGapLength', {'gapLength': gapLength});
  }

  @override
  Future<void> setPrintPageGapType(int gapType) async {
    await _channel.invokeMethod('setPrintPageGapType', {'gapType': gapType});
  }

  @override
  Future<void> setPrintSpeed(int speed) async {
    await _channel.invokeMethod('setPrintSpeed', {'speed': speed});
  }

  @override
  Future<bool> startDraw(double width, double height, int orientation) async {
    final bool result = await _channel.invokeMethod('startDraw', {
      'width': width,
      'height': height,
      'orientation': orientation,
    });
    return result;
  }
  @override
  Future<bool> drawImageWithImage(Uint8List image, double x, double y, double width, double height, int threshold) async {
    final bool result = await _channel.invokeMethod('drawImageWithImage', {
      'image': image,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'threshold': threshold,
    });
    return result;
  }
}
