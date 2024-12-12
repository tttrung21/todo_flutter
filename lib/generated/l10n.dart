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
  String get common_Success {
    return Intl.message(
      'Success',
      name: 'common_Success',
      desc: '',
      args: [],
    );
  }

  /// `Error occurred`
  String get common_Error {
    return Intl.message(
      'Error occurred',
      name: 'common_Error',
      desc: '',
      args: [],
    );
  }

  /// `Field cannot be empty!`
  String get common_EmptyField {
    return Intl.message(
      'Field cannot be empty!',
      name: 'common_EmptyField',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email`
  String get common_InvalidEmail {
    return Intl.message(
      'Invalid email',
      name: 'common_InvalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 8 characters long`
  String get common_PasswordErrorLength {
    return Intl.message(
      'Password must be at least 8 characters long',
      name: 'common_PasswordErrorLength',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get common_PasswordErrorMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'common_PasswordErrorMatch',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get common_Delete {
    return Intl.message(
      'Delete',
      name: 'common_Delete',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get common_Cancel {
    return Intl.message(
      'Cancel',
      name: 'common_Cancel',
      desc: '',
      args: [],
    );
  }

  /// `My Todo List`
  String get home_Title {
    return Intl.message(
      'My Todo List',
      name: 'home_Title',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get home_Complete {
    return Intl.message(
      'Completed',
      name: 'home_Complete',
      desc: '',
      args: [],
    );
  }

  /// `Empty Data`
  String get home_EmptyData {
    return Intl.message(
      'Empty Data',
      name: 'home_EmptyData',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get auth_SignIn {
    return Intl.message(
      'Sign In',
      name: 'auth_SignIn',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get auth_Register {
    return Intl.message(
      'Register',
      name: 'auth_Register',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get auth_Password {
    return Intl.message(
      'Password',
      name: 'auth_Password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get auth_ConfirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'auth_ConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Successfully create new account`
  String get auth_CreateSuccess {
    return Intl.message(
      'Successfully create new account',
      name: 'auth_CreateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Welcome!`
  String get auth_Welcome {
    return Intl.message(
      'Welcome!',
      name: 'auth_Welcome',
      desc: '',
      args: [],
    );
  }

  /// `to `
  String get auth_To {
    return Intl.message(
      'to ',
      name: 'auth_To',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account yet? Try `
  String get auth_NotHaveAccount {
    return Intl.message(
      'Don\'t have an account yet? Try ',
      name: 'auth_NotHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? Go `
  String get auth_AlreadyHaveAccount {
    return Intl.message(
      'Already have an account? Go ',
      name: 'auth_AlreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Add New Task`
  String get addTask_AddTask {
    return Intl.message(
      'Add New Task',
      name: 'addTask_AddTask',
      desc: '',
      args: [],
    );
  }

  /// `Task Title`
  String get addTask_TaskTitle {
    return Intl.message(
      'Task Title',
      name: 'addTask_TaskTitle',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get addTask_Category {
    return Intl.message(
      'Category',
      name: 'addTask_Category',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get addTask_Date {
    return Intl.message(
      'Date',
      name: 'addTask_Date',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get addTask_Time {
    return Intl.message(
      'Time',
      name: 'addTask_Time',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get addTask_Notes {
    return Intl.message(
      'Notes',
      name: 'addTask_Notes',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get addTask_Save {
    return Intl.message(
      'Save',
      name: 'addTask_Save',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get addTask_Update {
    return Intl.message(
      'Update',
      name: 'addTask_Update',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get setting_Settings {
    return Intl.message(
      'Settings',
      name: 'setting_Settings',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get setting_Language {
    return Intl.message(
      'Language',
      name: 'setting_Language',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get setting_LogOut {
    return Intl.message(
      'Log Out',
      name: 'setting_LogOut',
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
