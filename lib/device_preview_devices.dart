import 'package:device_preview/device_preview.dart';

final previewMobileDevices = DevicePreview.defaultDevices
    .where((device) => device.identifier.type == DeviceType.phone)
    .toList();

final previewDefaultDevice = Devices.ios.iPhone16ProMax;
