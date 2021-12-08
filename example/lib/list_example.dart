import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListExample extends StatelessWidget {
  const ListExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (_, i) => Container(
          width: 400,
          height: 100,
          color: (i % 2 == 0) ? Colors.red : Colors.grey,
        ),
      ),
    );
  }
}
