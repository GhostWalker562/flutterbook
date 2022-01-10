import 'package:flutter/material.dart';

class DevicePreviewProvider extends ChangeNotifier {
  DevicePreviewProvider();

  bool _show = false;

  get show => _show;

  void togglePreview() {
      _show = !_show;
      notifyListeners();
  }
}
