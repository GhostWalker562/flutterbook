

import 'package:flutter/services.dart';

class FileReader {
  static Future<String>? getContents(String path) {
    return rootBundle.loadString("$path.md");
  }
}
