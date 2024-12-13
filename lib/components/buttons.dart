import 'package:flutter/cupertino.dart';
import 'package:todo_app/style/color_style.dart';
import 'package:todo_app/style/text_style.dart';

class CircularCupertinoButton extends StatelessWidget {
  const CircularCupertinoButton({super.key, this.onPress, required this.title, this.style});

  final void Function()? onPress;
  final String title;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      borderRadius: BorderRadius.circular(50),
      padding: EdgeInsets.zero,
      disabledColor: ModColorStyle.disable,
      color: ModColorStyle.primary,
      onPressed: onPress,
      child: Text(title, style: style ?? ModTextStyle.button1.copyWith(color: ModColorStyle.white)),
    );
  }
}

class AuthCupertinoButton extends StatelessWidget {
  const AuthCupertinoButton({super.key, this.onPress, required this.title});

  final void Function()? onPress;
  final String title;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        borderRadius: BorderRadius.circular(16),
        color: ModColorStyle.primary,
        onPressed: onPress,
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(
            title,
            style: ModTextStyle.title2.copyWith(color: ModColorStyle.white),
          ),
        ));
  }
}