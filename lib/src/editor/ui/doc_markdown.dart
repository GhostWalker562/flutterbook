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

    return Markdown(
      selectable: true,
      controller: controller,
      data: markdown ?? DEFAULT_MARKDOWN,
      shrinkWrap: true,
    );
  }
}
