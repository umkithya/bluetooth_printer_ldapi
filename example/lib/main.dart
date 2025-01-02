import 'dart:async';

// import 'package:bluetooth_printer_ldapi/bluetooth_printer_ldapi.dart';
import 'package:bluetooth_printer_ldapi/bluetooth_printer_ldapi.dart';
import 'package:bluetooth_printer_ldapi/model/printer_info_model.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> printers = [];
  final _bluetoothPrinterLdapiPlugin = BluetoothPrinterLdapi();
  String status = '';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Plugin example app' ' Status: $status'),
          actions: [
            IconButton(
                onPressed: () async {
                 
                    // 72mm x 100mm
                    // 72mm x 50mm
                    // 72mm x 30mm
                   double labelWidth = 72.0;
                  double labelHeight = 100.0;
                  
                  double margin = 4.0;
                  bool result = await _bluetoothPrinterLdapiPlugin.startDraw(
                      labelWidth, labelHeight, 0);
                  print("result $result");

                  const url =
                      'https://hochgatterer.me/asset/finances/img/tips/QR-Code_FakeBill@2x.jpg';
                  bool result1 = await _bluetoothPrinterLdapiPlugin.drawImage(
                      url,
                      margin,
                      margin,
                      labelWidth - margin * 2,
                      labelHeight - margin * 2,
                      128);
                  print("result1 $result1");

                  await _bluetoothPrinterLdapiPlugin.endDraw();
                  await printOneLabel();

                  // bool result = await _bluetoothPrinterLdapiPlugin.dra(
                  //     labelWidth, labelHeight, 0);
                },
                icon: const Icon(Icons.print)),
            IconButton(
                onPressed: () async {
                  await _bluetoothPrinterLdapiPlugin.closePrinter();
                },
                icon: const Icon(Icons.remove_circle_outline_sharp))
          ],
        ),
        body: ListView.builder(
          itemCount: printers.length,
          itemBuilder: (context, index) => Center(
            child: Text(printers[index]),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final bool isSuccess =
                await _bluetoothPrinterLdapiPlugin.openPrinter(printers[0]);
            if (isSuccess) {
              status = "successful";
              setState(() {});
            } else {
              print('Connection failed');
              status = "failed";
              setState(() {});
            }
          },
          child: const Icon(Icons.connect_without_contact),
        ),
      ),
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    List<String> temp = [];
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      temp = await _bluetoothPrinterLdapiPlugin.scanPrinters();
      print("temp${temp.length}");
    } catch (e) {
      print("Ex:$e");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      printers = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> printOneLabel() async {
    PrinterInfo data =
        await _bluetoothPrinterLdapiPlugin.connectingPrinterDetailInfos();
    print("data ${data.toMap()}");
    await _bluetoothPrinterLdapiPlugin.print((bool isSuccess) {
      if (isSuccess) {
        print("Success!");
      } else {
        printOneLabel();
        print("Failure!");
      }
    });
  }
}
