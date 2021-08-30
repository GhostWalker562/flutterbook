import 'package:flutter/material.dart';

class GridProvider extends ChangeNotifier {
  GridProvider();

  bool _hasGrid = false;

  bool get grid => _hasGrid;

  void toggleGrid() {
    _hasGrid = !_hasGrid;
    notifyListeners();
  }
}
