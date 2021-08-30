import 'package:flutter/material.dart';

class ZoomProvider extends ChangeNotifier {
  ZoomProvider();

  double _zoom = 1;

  double get zoom => _zoom;

  void zoomIn() {
    _zoom += 0.25;
    notifyListeners();
  }

  void zoomOut() {
    _zoom = (_zoom - 0.25).clamp(0.5, 999);
    notifyListeners();
  }

  void resetZoom() {
    _zoom = 1;
    notifyListeners();
  }
}
