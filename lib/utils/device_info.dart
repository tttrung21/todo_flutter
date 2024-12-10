import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfo{
  static final DeviceInfo _instance = DeviceInfo._internal();
  factory DeviceInfo() => _instance;
  DeviceInfo._internal();

  String? deviceId;

  Future<void> getDeviceID() async {
    final devicePlugin = DeviceInfoPlugin();
    try {
      if (Platform.isIOS) {
        final iosInfo = await devicePlugin.iosInfo;
        deviceId = iosInfo.identifierForVendor;
      } else if (Platform.isAndroid) {
        final androidInfo = await devicePlugin.androidInfo;
        deviceId = androidInfo.id;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
  bool get isIos => Platform.isIOS;
}