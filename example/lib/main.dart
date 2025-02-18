import 'dart:async';
import 'dart:io';

// import 'package:bluetooth_printerService_ldapi/bluetooth_printerService_ldapi.dart';

import 'package:bluetooth_printer_ldapi/bluetooth_printer_ldapi.dart';
import 'package:bluetooth_printer_ldapi/model/printer_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _HomePageState extends State<HomePage> {
  List<String> printers = [];
  final _printerService = BluetoothPrinter();
  String status = '';
  bool loading = false;
  PrinterInfo? printerInfo;
  List<PrinterInfo>? printer = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () async {
              await scanPrinter();
            },
            icon: const Icon(Icons.search)),
        title: Text('Plugin example app' ' Status: $status'),
        actions: [
          IconButton(
              onPressed: () async {
                await pickImage(context);
              },
              icon: const Icon(Icons.print)),
          IconButton(
              onPressed: () async {
                await closePrinter();
              },
              icon: const Icon(Icons.close))
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: printer?.length,
              itemBuilder: (context, index) => ElevatedButton(
                onPressed: () async {
                  printerInfo = printer![index];
                  await connectPrinter();
                },
                child: Center(
                  child: Row(
                    children: [
                      Text(printer![index].name!),
                      if (status == 'Connected') ...[
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      ] else ...[
                        const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> closePrinter() async {
    await _printerService.close();
  }

  Future<void> connectPrinter() async {
    if (printerInfo != null) {
      debugPrint("printerInfo: ${printerInfo!.toMap()}");
      bool result = await _printerService.connectToPrinter(printerInfo!);
      status = result ? 'Connected' : 'Not Connected';
      setState(() {
        status = status;
      });
    } else {
      print('printerInfo is null');
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    await _printerService.init();
    // if (!mounted) return;
    // setState(() {
    //   loading = false;
    // });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 200,
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.file(File(image.path))),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Uint8List imageBytes = await image.readAsBytes();
                      if (!mounted) return;
                      await printImage(imageBytes);
                      if (!mounted) return;
                      Navigator.pop(context);
                    },
                    child: const Text('Print'),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      print('No image selected.');
    }
  }

  Future<void> printImage(Uint8List image) async {
    if (printerInfo != null) {
      bool result = await _printerService.printImage(image);
      status = result ? 'Connected' : 'Not Connected';
    } else {
      print('printerInfo is null');
    }
  }

  Future<void> scanPrinter() async {
    setState(() {
      loading = true;
    });
    printer = await _printerService.scanPrinters();
    setState(() {
      loading = false;
    });
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
