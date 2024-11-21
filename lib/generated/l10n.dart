// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Success`
  String get common_ThanhCong {
    return Intl.message(
      'Success',
      name: 'common_ThanhCong',
      desc: '',
      args: [],
    );
  }

  /// `Error occurred`
  String get common_LoiXayRa {
    return Intl.message(
      'Error occurred',
      name: 'common_LoiXayRa',
      desc: '',
      args: [],
    );
  }

  /// `Field cannot be empty!`
  String get common_LoiThongTinTrong {
    return Intl.message(
      'Field cannot be empty!',
      name: 'common_LoiThongTinTrong',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email`
  String get common_LoiEmailKhongHopLe {
    return Intl.message(
      'Invalid email',
      name: 'common_LoiEmailKhongHopLe',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 8 characters long`
  String get common_LoiMK8KyTu {
    return Intl.message(
      'Password must be at least 8 characters long',
      name: 'common_LoiMK8KyTu',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get common_LoiMKKhac {
    return Intl.message(
      'Passwords do not match',
      name: 'common_LoiMKKhac',
      desc: '',
      args: [],
    );
  }

  /// `My Todo List`
  String get home_TieuDe {
    return Intl.message(
      'My Todo List',
      name: 'home_TieuDe',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get home_HoanThanh {
    return Intl.message(
      'Completed',
      name: 'home_HoanThanh',
      desc: '',
      args: [],
    );
  }

  /// `Empty Data`
  String get home_KhongCoDuLieu {
    return Intl.message(
      'Empty Data',
      name: 'home_KhongCoDuLieu',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get auth_DangNhap {
    return Intl.message(
      'Sign In',
      name: 'auth_DangNhap',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get auth_DangKy {
    return Intl.message(
      'Register',
      name: 'auth_DangKy',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get auth_MatKhau {
    return Intl.message(
      'Password',
      name: 'auth_MatKhau',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get auth_XacNhanMK {
    return Intl.message(
      'Confirm Password',
      name: 'auth_XacNhanMK',
      desc: '',
      args: [],
    );
  }

  /// `Successfully create new account`
  String get auth_ThanhCongTaoTK {
    return Intl.message(
      'Successfully create new account',
      name: 'auth_ThanhCongTaoTK',
      desc: '',
      args: [],
    );
  }

  /// `Add New Task`
  String get addTask_ThemViec {
    return Intl.message(
      'Add New Task',
      name: 'addTask_ThemViec',
      desc: '',
      args: [],
    );
  }

  /// `Task Title`
  String get addTask_TieuDeViec {
    return Intl.message(
      'Task Title',
      name: 'addTask_TieuDeViec',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get addTask_Loai {
    return Intl.message(
      'Category',
      name: 'addTask_Loai',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get addTask_Ngay {
    return Intl.message(
      'Date',
      name: 'addTask_Ngay',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get addTask_Gio {
    return Intl.message(
      'Time',
      name: 'addTask_Gio',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get addTask_GhiChu {
    return Intl.message(
      'Notes',
      name: 'addTask_GhiChu',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get addTask_Luu {
    return Intl.message(
      'Save',
      name: 'addTask_Luu',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
