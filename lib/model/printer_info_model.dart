class PrinterInfo {
  int deviceType; // DEVICE_TYPE_xxx, 热敏打印机/热转印打印机等等
  int deviceDPI; // 打印精度，DPI
  int deviceWidth; // 打印宽度，mm
  String? deviceName; // 设备名称，包括型号和序列号
  String? deviceVersion; // 硬件版本号
  String? softwareVersion; // 软件版本号
  String? deviceAddress; // MAC 地址
  String? manufacturer; // 厂商名称
  String? seriesName; // 产品系列名称
  String? devIntName; // 内部型号名称

  String? hardwareFlags; // 硬件标志位
  int softwareFlags; // 软件标志位

  // Constructor
  PrinterInfo({
    required this.deviceType,
    required this.deviceDPI,
    required this.deviceWidth,
    this.deviceName,
    this.deviceVersion,
    this.softwareVersion,
    this.deviceAddress,
    this.manufacturer,
    this.seriesName,
    this.devIntName,
    this.hardwareFlags,
    required this.softwareFlags,
  });

  // toMap function to convert PrinterInfo object to Map
  Map<String, dynamic> toMap() {
    return {
      'deviceType': deviceType,
      'deviceDPI': deviceDPI,
      'deviceWidth': deviceWidth,
      'deviceName': deviceName,
      'deviceVersion': deviceVersion,
      'softwareVersion': softwareVersion,
      'deviceAddress': deviceAddress,
      'manufacturer': manufacturer,
      'seriesName': seriesName,
      'devIntName': devIntName,
      'hardwareFlags': hardwareFlags,
      'softwareFlags': softwareFlags,
    };
  }

  // fromMap function to create PrinterInfo object from Map
  factory PrinterInfo.fromMap(Map<String, dynamic> map) {
    return PrinterInfo(
      deviceType: map['deviceType'],
      deviceDPI: map['deviceDPI'],
      deviceWidth: map['deviceWidth'],
      deviceName: map['deviceName'],
      deviceVersion: map['deviceVersion'],
      softwareVersion: map['softwareVersion'],
      deviceAddress: map['deviceAddress'],
      manufacturer: map['manufacturer'],
      seriesName: map['seriesName'],
      devIntName: map['devIntName'],
      hardwareFlags: map['hardwareFlags'],
      softwareFlags: map['softwareFlags'],
    );
  }
}
