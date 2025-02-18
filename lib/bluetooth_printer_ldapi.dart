import 'dart:io';

import 'package:bluetooth_printer_ldapi/model/printer_info_model.dart';
import 'package:flutter/services.dart';

import 'bluetooth_printer_ldapi_platform_interface.dart';

class BluetoothPrinter {
  static final BluetoothPrinterLdapi _instance = BluetoothPrinterLdapi();
  static BluetoothPrinterLdapi get instance => _instance;
  Future<void> close() async {
    if (Platform.isAndroid) {
      await instance.closePrinterAndroid();
    } else if (Platform.isIOS) {
      await instance.closePrinter();
    } else {
      throw UnimplementedError();
    }
  }

  Future<bool> connectToPrinter(PrinterInfo printer) async {
    try {
      if (Platform.isAndroid) {
        if (printer.androidInfo == null) {
          print("PrinterInfoIos or deviceName can't be null");
          return false;
        }
        await instance.connnectPrinterAndroid(printer.androidInfo!);
        return true;
      } else if (Platform.isIOS) {
        if (printer.iosInfo == null || printer.iosInfo?.deviceName == null) {
          print("PrinterInfoIos or deviceName can't be null");
          return false;
        }
        await instance.openPrinter(printer.iosInfo!.deviceName!);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> init() async {
    if (Platform.isAndroid) {
      await instance.initPrinterAndroid();
    }
  }

  Future<bool> printImage(Uint8List image, {bool isOrientation = false}) async {
    if (Platform.isAndroid) {
      String result =
          await instance.printImageAndroid(image, isOrientation: isOrientation);
      return true;
    } else if (Platform.isIOS) {
      // 72mm x 100mm
      // 72mm x 50mm
      // 72mm x 30mm
      double labelWidth = 72.0;
      double labelHeight = 100.0;
      double margin = 4.0;
      bool result = await instance.startDraw(
          labelWidth, labelHeight, isOrientation ? 1 : 0);
      print("result $result");

      // const url =
      //     'https://hochgatterer.me/asset/finances/img/tips/QR-Code_FakeBill@2x.jpg';
      bool result1 = await instance.drawImageWithImage(image, margin, margin,
          labelWidth - margin * 2, labelHeight - margin * 2, 128);
      // bool result1 = await instance.drawImage(url, margin, margin,
      //     labelWidth - margin * 2, labelHeight - margin * 2, 128);
      print("result1 $result1");

      await instance.endDraw();
      await _printOneLabel();
      if (result1 == true) {
        return true;
      }
      return false;
    } else {
      return false;
    }
  }

  Future<List<PrinterInfo>> scanPrinters() async {
    List<PrinterInfo> printerInfos = [];
    if (Platform.isAndroid) {
      final List<PrinterInfoAndroid> printerInfoAndroids =
          await instance.scanPrinterForAndroid();
      for (PrinterInfoAndroid printerInfoAndroid in printerInfoAndroids) {
        printerInfos.add(PrinterInfo(
          name: printerInfoAndroid.shownName,
          deviceAddress: printerInfoAndroid.macAddress,
          type: printerInfoAndroid.addressType,
          androidInfo: printerInfoAndroid,
        ));
      }
      return printerInfos;
    } else if (Platform.isIOS) {
      final List<String> printerInfoIos = await instance.scanPrinters();
      for (String name in printerInfoIos) {
        printerInfos.add(PrinterInfo(
          name: name,
          iosInfo: PrinterInfoIos(
              deviceName: name,
              deviceType: 0,
              deviceDPI: 0,
              deviceWidth: 0,
              softwareFlags: 0),
        ));
      }
      return printerInfos;
    } else {
      return [];
    }
  }

  Future<void> _printOneLabel() async {
    PrinterInfoIos data = await instance.connectingPrinterDetailInfos();
    print("data ${data.toMap()}");
    await instance.print((bool isSuccess) {
      if (isSuccess) {
        print("Success!");
      } else {
        _printOneLabel();
        print("Failure!");
      }
    });
  }
}

class BluetoothPrinterLdapi implements BluetoothPrinterLdapiPlatform {
  @override
  Future<void> closePrinter() async {
    await BluetoothPrinterLdapiPlatform.instance.closePrinter();
  }

  @override
  Future<void> closePrinterAndroid() async {
    await BluetoothPrinterLdapiPlatform.instance.closePrinterAndroid();
  }

  @override
  Future<PrinterInfoIos> connectingPrinterDetailInfos() {
    return BluetoothPrinterLdapiPlatform.instance
        .connectingPrinterDetailInfos();
  }

  @override
  Future<String> connnectPrinterAndroid(PrinterInfoAndroid printer) {
    return BluetoothPrinterLdapiPlatform.instance
        .connnectPrinterAndroid(printer);
  }

  @override
  Future<bool> drawBarcode(
      String text, double x, double y, double width, double height) {
    return BluetoothPrinterLdapiPlatform.instance
        .drawBarcode(text, x, y, width, height);
  }

  @override
  Future<bool> drawImage(String fileUrl, double x, double y, double width,
      double height, int threshold) {
    return BluetoothPrinterLdapiPlatform.instance
        .drawImage(fileUrl, x, y, width, height, threshold);
  }

  @override
  Future<bool> drawImageWithImage(Uint8List image, double x, double y,
      double width, double height, int threshold) {
    return BluetoothPrinterLdapiPlatform.instance
        .drawImageWithImage(image, x, y, width, height, threshold);
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
  Future<void> initPrinterAndroid() {
    return BluetoothPrinterLdapiPlatform.instance.initPrinterAndroid();
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
  Future<String> printImageAndroid(Uint8List image,
      {bool isOrientation = false}) {
    return BluetoothPrinterLdapiPlatform.instance
        .printImageAndroid(image, isOrientation: isOrientation);
  }

  @override
  Future<List<PrinterInfoAndroid>> scanPrinterForAndroid() {
    return BluetoothPrinterLdapiPlatform.instance.scanPrinterForAndroid();
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
}
