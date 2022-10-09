import 'package:flutter/material.dart';

class ApplicationController extends ChangeNotifier {
  Locale appLocale = const Locale('tr', 'TR');
  Map appLocales = {
    'en': const Locale('en', ''),
    'tr': const Locale('tr', 'TR')
  };

  changeAppLocale(locale) {
    appLocale = appLocales[locale];
    notifyListeners();
  }
}
