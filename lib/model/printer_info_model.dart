class PrinterInfo implements PrinterInfoBase {
  PrinterInfoAndroid? androidInfo;
  PrinterInfoIos? iosInfo;

  @override
  String? deviceAddress;

  @override
  String? name;

  @override
  String? type;

  // Constructor
  PrinterInfo({
    this.androidInfo,
    this.iosInfo,
    this.deviceAddress,
    this.name,
    this.type,
  });

  // fromMap function to create PrinterInfo object from Map
  factory PrinterInfo.fromMap(Map<String, dynamic> map) {
    return PrinterInfo(
      androidInfo: map['androidInfo'] != null
          ? PrinterInfoAndroid.fromMap(map['androidInfo'])
          : null,
      iosInfo: map['iosInfo'] != null
          ? PrinterInfoIos.fromMap(map['iosInfo'])
          : null,
    );
  }

  // toMap function to convert PrinterInfo object to Map
  Map<String, dynamic> toMap() {
    return {
      'androidInfo': androidInfo?.toMap(),
      'iosInfo': iosInfo?.toMap(),
    };
  }
}

class PrinterInfoAndroid {
  String? macAddress;
  String? shownName;
  String? addressType;

  // Constructor
  PrinterInfoAndroid({
    this.macAddress,
    this.shownName,
    this.addressType,
  });

  // fromMap function to create PrinterInfoAndroid object from Map
  factory PrinterInfoAndroid.fromMap(Map<String, dynamic> map) {
    return PrinterInfoAndroid(
      macAddress: map['macAddress'],
      shownName: map['shownName'],
      addressType: map['addressType'],
    );
  }

  // toMap function to convert PrinterInfoAndroid object to Map
  Map<String, dynamic> toMap() {
    return {
      'macAddress': macAddress,
      'shownName': shownName,
      'addressType': addressType,
    };
  }
}

interface class PrinterInfoBase {
  String? name;
  String? deviceAddress;
  String? type;
}

class PrinterInfoIos {
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
  PrinterInfoIos({
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

  // fromMap function to create PrinterInfo object from Map
  factory PrinterInfoIos.fromMap(Map<String, dynamic> map) {
    return PrinterInfoIos(
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
}
