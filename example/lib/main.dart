import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

// import 'package:bluetooth_printerService_ldapi/bluetooth_printerService_ldapi.dart';

import 'package:bluetooth_printer_ldapi/bluetooth_printer_ldapi.dart';
import 'package:bluetooth_printer_ldapi/model/printer_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

final repaintState = GlobalKey<_RecieptPageState>();

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

class ReceiptBank {
  static final receiptData = [
    ReceiptBank(title: "Transction Amount", value: "\$3000"),
    ReceiptBank(title: "Transaction Type", value: "Investment"),
    ReceiptBank(title: "Narration", value: "This is the transaction narration"),
  ];
  final String title;
  final String value;

  ReceiptBank({required this.title, required this.value});
}

class RecieptPage extends StatefulWidget {
  final void Function(Uint8List) onPrint;
  const RecieptPage({super.key, required this.onPrint});
  @override
  State<RecieptPage> createState() => _RecieptPageState();
}

class _HomePageState extends State<HomePage> {
  List<String> printers = [];
  final _printerService = BluetoothPrinter();
  String status = '';
  bool loading = false;
  PrinterInfo? printerInfo;
  List<PrinterInfo>? printer = [];
  Uint8List? imageBytesScreenshot;

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
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
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
                ),
                Expanded(
                    child: imageBytesScreenshot == null
                        ? const Text("Receipt is null")
                        : Image.memory(imageBytesScreenshot!)),
                Expanded(
                  child: RecieptPage(
                      key: repaintState,
                      onPrint: (img) async {
                        setState(() {
                          imageBytesScreenshot = img;
                        });
                      }),
                )
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await repaintState.currentState!.downloadTransactionReceipt();
          if (imageBytesScreenshot != null) {
            if (!mounted) return;
            await printImage(imageBytesScreenshot!);
          }
        },
        child: const Icon(Icons.print),
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

class _RecieptPageState extends State<RecieptPage> {
  GlobalKey<State<StatefulWidget>> widget1RenderKey =
      GlobalKey<State<StatefulWidget>>();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 300,
      child: RepaintBoundary(
        key: widget1RenderKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Transaction Receipt',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  for (final receiptItem in ReceiptBank.receiptData)
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              receiptItem.title,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    receiptItem.value,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> downloadTransactionReceipt() async {
    // Get the view context from the key
    final RenderRepaintBoundary boundary = widget1RenderKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;

    final ui.Image image = await boundary.toImage(pixelRatio: 3.7795275591);
    double dpi = MediaQuery.of(context).devicePixelRatio *
        160; // Default is 160 for MDPI screens
    double targetWidth = (70 * dpi) / 25.4;
    double targetHeight = (100 * dpi) / 25.4;
// Converts view to png
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();

    final img.Image imageLib = img.decodeImage(uint8List)!;
    img.Image resizedImage = img.copyResize(imageLib,
        width: targetWidth.toInt(), height: targetHeight.toInt());
    final Uint8List resizedUint8List = img.encodePng(resizedImage);
// Extract the UI8List

    widget.onPrint(resizedUint8List);
  }
}
