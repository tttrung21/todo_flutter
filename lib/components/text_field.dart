import 'package:flutter/material.dart';
import 'package:todo_app/style/color_style.dart';
import 'package:todo_app/style/text_style.dart';

class CommonTextFormField extends StatelessWidget {
  final String placeholder;
  final TextEditingController tec;
  final bool readOnly;
  final void Function()? onTap;
  final int? maxLine;
  final bool isObscure;
  final bool isLabelText;
  final FormFieldValidator<String>? validator;
  final Image? image;

  const CommonTextFormField(
      this.placeholder,
      this.tec, {
        Key? key,
        this.readOnly = false,
        this.onTap,
        this.maxLine = 1,
        this.isObscure = false,
        this.isLabelText = false,
        this.validator,
        this.image,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      maxLines: maxLine,
      readOnly: readOnly,
      onTap: onTap,
      controller: tec,
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: isLabelText ? placeholder : null,
        suffixIcon: image,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: ModColorStyle.border),
        ),
        hintText: placeholder,
        hintStyle: ModTextStyle.placeholder.copyWith(color: ModColorStyle.subTitle),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: ModColorStyle.border),
        ),
      ),
    );
  }
}