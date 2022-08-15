import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

const defaultMarkDown = """
## No markdown provided
""";

class DocMarkDown extends StatelessWidget {
  final String? markdown;

  const DocMarkDown({
    Key? key,
    this.markdown,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Markdown(
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
      padding: EdgeInsets.only(top: 8),
      data: markdown ?? defaultMarkDown,
      selectable: true,
      shrinkWrap: true,
    );
  }
}
