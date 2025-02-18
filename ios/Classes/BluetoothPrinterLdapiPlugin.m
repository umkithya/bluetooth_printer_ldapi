#import "BluetoothPrinterLdapiPlugin.h"
#import "LPAPI.h"

@implementation BluetoothPrinterLdapiPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"bluetooth_printer_ldapi"
            binaryMessenger:[registrar messenger]];
  BluetoothPrinterLdapiPlugin* instance = [[BluetoothPrinterLdapiPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"setPrintPageGapType" isEqualToString:call.method]) {
        NSNumber *gapType = call.arguments[@"gapType"];
        [LPAPI setPrintPageGapType:[gapType intValue]];
        result(nil);
    } else if ([@"setPrintPageGapLength" isEqualToString:call.method]) {
        NSNumber *gapLength = call.arguments[@"gapLength"];
        [LPAPI setPrintPageGapLength:[gapLength intValue]];
        result(nil);
    } else if ([@"setPrintDarkness" isEqualToString:call.method]) {
        NSNumber *darkness = call.arguments[@"darkness"];
        [LPAPI setPrintDarkness:[darkness intValue]];
        result(nil);
    } else if ([@"setPrintSpeed" isEqualToString:call.method]) {
        NSNumber *speed = call.arguments[@"speed"];
        [LPAPI setPrintSpeed:[speed intValue]];
        result(nil);
    } else if ([@"scanPrinters" isEqualToString:call.method]) {
        [LPAPI scanPrinters:^(NSArray *scanedPrinterNames) {
            result(scanedPrinterNames);
        }];
    } else if ([@"openPrinter" isEqualToString:call.method]) {
        NSString *printerName = call.arguments[@"printerName"];
        [LPAPI openPrinter:printerName completion:^(BOOL isSuccess) {
            result(@(isSuccess));
        }];
    } else if ([@"closePrinter" isEqualToString:call.method]) {
        [LPAPI closePrinter];
        result(nil);
    } else if ([@"startDraw" isEqualToString:call.method]) {
        NSNumber *width = call.arguments[@"width"];
        NSNumber *height = call.arguments[@"height"];
        NSNumber *orientation = call.arguments[@"orientation"];
        BOOL success = [LPAPI startDraw:[width doubleValue]
                                height:[height doubleValue]
                           orientation:[orientation intValue]];
        result(@(success));
    } else if ([@"endDraw" isEqualToString:call.method]) {
        UIImage *image = [LPAPI endDraw];
        NSData *imageData = UIImagePNGRepresentation(image);
        result([FlutterStandardTypedData typedDataWithBytes:imageData]);
    } else if ([@"print" isEqualToString:call.method]) {
        [LPAPI print:^(BOOL isSuccess) {
            result(@(isSuccess));
        }];
    } else if ([@"drawImage" isEqualToString:call.method]) {
        NSString *file = call.arguments[@"file"];
        NSNumber *x = call.arguments[@"x"];
        NSNumber *y = call.arguments[@"y"];
        NSNumber *width = call.arguments[@"width"];
        NSNumber *height = call.arguments[@"height"];
        NSNumber *threshold = call.arguments[@"threshold"];
        BOOL success = [LPAPI drawImage:file
                                     x:[x doubleValue]
                                     y:[y doubleValue]
                                 width:[width doubleValue]
                                height:[height doubleValue]
                            threshold:[threshold intValue]];
        result(@(success));
    }
    else if ([@"drawImageWithImage" isEqualToString:call.method]) {
        FlutterStandardTypedData *imageData = call.arguments[@"image"];
        NSNumber *x = call.arguments[@"x"];
        NSNumber *y = call.arguments[@"y"];
        NSNumber *width = call.arguments[@"width"];
        NSNumber *height = call.arguments[@"height"];
        NSNumber *threshold = call.arguments[@"threshold"];
        UIImage *image = [UIImage imageWithData:imageData.data];
        BOOL success = [LPAPI drawImageWithImage:image
                                               x:[x doubleValue]
                                               y:[y doubleValue]
                                           width:[width doubleValue]
                                          height:[height doubleValue]
                                       threshold:[threshold intValue]];
        result(@(success));
    }
     else if ([@"drawText" isEqualToString:call.method]) {
        NSString *text = call.arguments[@"text"];
        NSNumber *x = call.arguments[@"x"];
        NSNumber *y = call.arguments[@"y"];
        NSNumber *width = call.arguments[@"width"];
        NSNumber *height = call.arguments[@"height"];
        NSNumber *fontHeight = call.arguments[@"fontHeight"];
        BOOL success = [LPAPI drawText:text
                                     x:[x doubleValue]
                                     y:[y doubleValue]
                                 width:[width doubleValue]
                                height:[height doubleValue]
                            fontHeight:[fontHeight doubleValue]];
        result(@(success));
    } else if ([@"drawBarcode" isEqualToString:call.method]) {
        NSString *text = call.arguments[@"text"];
        NSNumber *x = call.arguments[@"x"];
        NSNumber *y = call.arguments[@"y"];
        NSNumber *width = call.arguments[@"width"];
        NSNumber *height = call.arguments[@"height"];
        BOOL success = [LPAPI drawBarcode:text
                                        x:[x doubleValue]
                                        y:[y doubleValue]
                                    width:[width doubleValue]
                                   height:[height doubleValue]];
        result(@(success));
    } else if ([@"drawQRCode" isEqualToString:call.method]) {
        NSString *text = call.arguments[@"text"];
        NSNumber *x = call.arguments[@"x"];
        NSNumber *y = call.arguments[@"y"];
        NSNumber *width = call.arguments[@"width"];
        BOOL success = [LPAPI drawQRCode:text
                                        x:[x doubleValue]
                                        y:[y doubleValue]
                                    width:[width doubleValue]];
        result(@(success));
    } else if ([@"connectingPrinterDetailInfos" isEqualToString:call.method]) {
        PrinterInfo *printerInfo = [LPAPI connectingPrinterDetailInfos];
        NSMutableDictionary *printerInfoDict = [NSMutableDictionary dictionary];
        if (printerInfo.deviceType) [printerInfoDict setObject:@(printerInfo.deviceType) forKey:@"deviceType"];
        if (printerInfo.deviceDPI) [printerInfoDict setObject:@(printerInfo.deviceDPI) forKey:@"deviceDPI"];
        if (printerInfo.deviceWidth) [printerInfoDict setObject:@(printerInfo.deviceWidth) forKey:@"deviceWidth"];
        if (printerInfo.deviceName) [printerInfoDict setObject:printerInfo.deviceName forKey:@"deviceName"];
        if (printerInfo.deviceVersion) [printerInfoDict setObject:printerInfo.deviceVersion forKey:@"deviceVersion"];
        if (printerInfo.softwareVersion) [printerInfoDict setObject:printerInfo.softwareVersion forKey:@"softwareVersion"];
        if (printerInfo.deviceAddress) [printerInfoDict setObject:printerInfo.deviceAddress forKey:@"deviceAddress"];
        if (printerInfo.manufacturer) [printerInfoDict setObject:printerInfo.manufacturer forKey:@"manufacturer"];
        if (printerInfo.seriesName) [printerInfoDict setObject:printerInfo.seriesName forKey:@"seriesName"];
        if (printerInfo.devIntName) [printerInfoDict setObject:printerInfo.devIntName forKey:@"devIntName"];
        if (printerInfo.hardwareFlags) [printerInfoDict setObject:printerInfo.hardwareFlags forKey:@"hardwareFlags"];
        if (printerInfo.softwareFlags) [printerInfoDict setObject:@(printerInfo.softwareFlags) forKey:@"softwareFlags"];
        result(printerInfoDict);
    }
      else {
        result(FlutterMethodNotImplemented);
    }
}

@end

