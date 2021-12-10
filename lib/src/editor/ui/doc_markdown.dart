import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutterbook/src/shared/const.dart';
import 'package:flutterbook/src/utils/utils.dart';

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
        builder: (context, snapshot) {
          return Tooltip(
            message: "Copy Code Snippet",
            child: Markdown(
              onTapText: () {
                Clipboard.setData(
                        new ClipboardData(text: snapshot.data.toString()))
                    .then((_) {
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("Copy Code Snippet")));
                });
              },
              controller: controller,
              data: snapshot.data.toString(),
              selectable: true,
              shrinkWrap: true,
            ),
          );
        });
  }
}
