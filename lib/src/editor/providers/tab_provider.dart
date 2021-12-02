import 'package:flutter/material.dart';
import 'package:flutterbook/src/editor/ui/editor_tabs.dart';

class TabProvider extends ChangeNotifier {
  TabProvider();
  FlutterBookTab _tab = FlutterBookTab.canvas;

  FlutterBookTab get tab => _tab;

  setTab(selectedTab) {
    _tab = selectedTab;
    notifyListeners();
  }
}
