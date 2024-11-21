import 'package:flutter/material.dart';

import '../style/color_style.dart';
import '../style/text_style.dart';

Widget normalTextFormField(String placeholder, TextEditingController tec,
    {bool readOnly = false,
    void Function()? onTap,
    int? maxLine = 1,
    bool isObscure = false,
    FormFieldValidator<String>? validator}) {
  return TextFormField(
    validator: validator,
    maxLines: maxLine,
    readOnly: readOnly,
    onTap: onTap,
    controller: tec,
    obscureText: isObscure,
    decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: ModColorStyle.border)),
        hintText: placeholder,
        hintStyle: ModTextStyle.placeholder.copyWith(color: ModColorStyle.subTitle),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: ModColorStyle.border))),
  );
}
