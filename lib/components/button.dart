import 'package:flutter/cupertino.dart';
import 'package:todo_app/style/color_style.dart';
import 'package:todo_app/style/text_style.dart';

Widget normalCupertinoButton({void Function()? onPress, String title = '', TextStyle? style}) {
  return CupertinoButton(
    borderRadius: BorderRadius.circular(50),
    padding: EdgeInsets.zero,
    disabledColor: ModColorStyle.disable,
    color: ModColorStyle.primary,
    onPressed: onPress,
    child: Text(title, style: style ?? ModTextStyle.button1.copyWith(color: ModColorStyle.white)),
  );
}
