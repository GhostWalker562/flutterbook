import 'package:flutter/material.dart';

/// This class is a test component

class TestComponent extends StatelessWidget {
  final String s;

  /// I got a string
  const TestComponent({Key? key, required this.s}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
        child: IconButton(
      icon: Icon(Icons.smartphone),
      onPressed: () {},
    ));
  }
}
