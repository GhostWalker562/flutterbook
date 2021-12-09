import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutterbook/src/shared/const.dart';

class DocMarkDown extends StatelessWidget {
  final Future<String>? markdown;

  const DocMarkDown({
    Key? key,
    this.markdown,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();

    return FutureBuilder(
        future: markdown,
        initialData: DEFAULT_MARKDOWN,
        builder: (context, projectSnap) {
          return Markdown(
            controller: controller,
            data: projectSnap.data.toString(),
            selectable: true,
            shrinkWrap: true,
          );
        });
  }
}
