import 'package:flutter/material.dart';

class SettingsController extends ChangeNotifier {
  bool _highContrast = false;
  double _textScaleFactor = 1.0;

  bool get highContrast => _highContrast;
  double get textScaleFactor => _textScaleFactor;

  void setHighContrast(bool value) {
    if (_highContrast != value) {
      _highContrast = value;
      notifyListeners();
    }
  }

  void setTextScaleFactor(double value) {
    if (_textScaleFactor != value) {
      _textScaleFactor = value;
      notifyListeners();
    }
  }
}