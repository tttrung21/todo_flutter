import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:todo_app/style/color_style.dart';

class ShowLoading{
  static void loadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: const Color(0xff1C2430).withOpacity(0.3),
      builder: (context) {
        return const PopScope(
          canPop: false,
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            content: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                SpinKitRipple(
                  color: ModColorStyle.white,
                  size: 100,
                  borderWidth: 40,
                ),
                SpinKitRing(
                  color: ModColorStyle.white,
                  size: 60,
                  lineWidth: 4,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}