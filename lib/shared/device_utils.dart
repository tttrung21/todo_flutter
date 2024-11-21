import 'package:flutter/material.dart';

class DeviceUtils {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double safeAreaHeight;
  static late double statusBarHeight;
  static late double bottomPadding;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    statusBarHeight = _mediaQueryData.padding.top;
    bottomPadding = _mediaQueryData.padding.bottom;
    safeAreaHeight = screenHeight - statusBarHeight - bottomPadding;
  }
}
