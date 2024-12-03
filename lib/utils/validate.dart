import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/generated/l10n.dart';

class CommonValidate {
  static String? validateEmail(String? value, BuildContext context) {
    final emptyError = Validator().validateNotEmpty(value, context);
    if (emptyError != null) return emptyError;

    final validError = Validator().validateEmail(value!, context);
    if (validError != null) return validError;

    return null;
  }

  static String? validatePassword(String? value, BuildContext context) {
    final emptyError = Validator().validateNotEmpty(value, context);
    if (emptyError != null) return emptyError;

    final lengthError = Validator().validateMinLength(value, context);
    if (lengthError != null) return lengthError;

    return null;
  }

  static String? validateConfirm(String? value1, String? value2, BuildContext context) {
    final emptyError = Validator().validateNotEmpty(value1, context);
    if (emptyError != null) return emptyError;

    final matchError = Validator().validateMatch(value1, value2, context);
    if (matchError != null) return matchError;

    return null;
  }

  static String? validateEmpty(String? value, BuildContext context) {
    final emptyError = Validator().validateNotEmpty(value, context);
    if (emptyError != null) return emptyError;
    return null;
  }
}

class Validator {
  String? validateNotEmpty(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return S.of(context).common_EmptyField;
    }
    return null;
  }

  String? validateMatch(String? value1, String? value2, BuildContext context) {
    if (value1 != value2) {
      return S.of(context).common_PasswordErrorMatch;
    }
    return null;
  }

  String? validateMinLength(String? value, BuildContext context) {
    if (value != null && value.length < 8) {
      return S.of(context).common_PasswordErrorLength;
    }
    return null;
  }

  String? validateEmail(String value, BuildContext context) {
    if (!EmailValidator.validate(value)) {
      return S.of(context).common_InvalidEmail;
    }
    return null;
  }
}
