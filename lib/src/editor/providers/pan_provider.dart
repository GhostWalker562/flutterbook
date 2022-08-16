import 'package:flutter/material.dart';

class PanProvider extends ChangeNotifier {
  PanProvider();

  bool _panEnabled = false;

  get panEnabled => _panEnabled;

  void toggle() {
    _panEnabled = !_panEnabled;
    notifyListeners();
  }
}
