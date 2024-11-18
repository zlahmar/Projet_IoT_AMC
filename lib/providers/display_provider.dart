import 'package:flutter/material.dart';

enum DisplayMode { clock, temperatureHumidity, scrollingMessage, audioSpectrum }

class DisplayProvider with ChangeNotifier {
  DisplayMode _currentMode = DisplayMode.clock;

  DisplayMode get currentMode => _currentMode;

  void setMode(DisplayMode mode) {
    _currentMode = mode;
    notifyListeners();
  }
}
