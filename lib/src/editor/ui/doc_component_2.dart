import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutterbook/src/utils/extensions.dart';
import 'package:flutterbook/src/utils/utils.dart';
import 'package:recase/recase.dart';

class DocPanel2 extends StatefulWidget {
  final Widget component;
  final String? docName;
  final String stateName;

  const DocPanel2({
    Key? key,
    required this.component,
    required this.stateName,
    this.docName,
  }) : super(key: key);

  @override
  _DocPanel2State createState() => _DocPanel2State();
}

class _DocPanel2State extends State<DocPanel2> {
  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();
    const String _markdownData = """
## Code blocks
Formatted Dart code looks really pretty too:
    ```
    void main() {
      runApp(MaterialApp(
        home: Scaffold(
          body: Markdown(data: markdownData),
        ),
      ));
    }
    ```
""";

    return FutureBuilder(
      future: loadAsset(context, widget.docName),
      initialData: _markdownData,
      builder: (BuildContext context, AsyncSnapshot<String> text) {
        return Expanded(
          child: Markdown(
            controller: controller,
            data: text.data ?? _markdownData,
          ),
        );
      },
    );
  }
}

Future<String> loadAsset(context, docName) async {
  ReCase doc = new ReCase(docName);
  final docNameSnake = doc.snakeCase;
  return await rootBundle.loadString("lib/doc/$docNameSnake/$docName/$docName.md");
}
