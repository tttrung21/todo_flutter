import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConvertUtils{
  static String dMy(dynamic date) {
    if (date == null) {
      return '';
    }
    if (date.runtimeType == String) {
      final tmp = DateTime.tryParse(date);
      return DateFormat('dd/MM/yyyy').format(tmp!);
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }
  static String hms(TimeOfDay date) {
    final hour = date.hour;
    final minute = date.minute;
    final tz = date.period.name;
    return '${hour < 10 ? '0$hour' : hour}:${minute < 10 ? '0$minute' : minute} ${tz.toUpperCase()} ';
  }
}