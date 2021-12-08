

import 'package:flutter/services.dart';

class FileReader {
  Future<String>? getContents(String path) {
    return rootBundle.loadString("$path.md");
  }
}