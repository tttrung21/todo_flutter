import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/shared/configs.dart';

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
extension DateTimeExtension on DateTime{

  Future<String> formattedMonth() async{
    final prefs = await SharedPreferences.getInstance();
    final formatter = DateFormat('MMMM, yyyy', prefs.getString(Configs.languageKey) == 'vi' ? 'vi_VN' : 'en_US');
    final String monthYear = formatter.format(this);
    return '${monthYear[0].toUpperCase()}${monthYear.substring(1)}';
  }
}