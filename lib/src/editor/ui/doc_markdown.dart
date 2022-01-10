import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutterbook/src/shared/const.dart';

class DocMarkDown extends StatelessWidget {
  final String? markdown;

  const DocMarkDown({
    Key? key,
    this.markdown,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();

    return Tooltip(
      message: "Copy Code Snippet",
      child: Markdown(
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
        onTapText: () {
          Clipboard.setData(new ClipboardData(text: markdown ?? ''));
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Copy Code Snippet")));
        },
        controller: controller,
        data: markdown ?? DEFAULT_MARKDOWN,
        selectable: true,
        shrinkWrap: true,
      ),
    );
  }
}
