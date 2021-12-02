import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutterbook/src/editor/ui/copy_text.dart';
import 'package:flutterbook/src/editor/ui/styled_icon_button.dart';
import 'package:flutterbook/src/utils/extensions.dart';
import 'package:flutterbook/src/utils/radii.dart';

class DocPanel2 extends StatefulWidget {
  final Widget component;
  final String? docs;
  final String? docPath;
  final String stateName;

  const DocPanel2({
    Key? key,
    required this.component,
    this.docs,
    required this.stateName,
    this.docPath,
  }) : super(key: key);

  @override
  _DocPanel2State createState() => _DocPanel2State();
}

class _DocPanel2State extends State<DocPanel2> {
  bool expanded = false;
  double _zoom = 1;
  get zoom => _zoom;

  void zoomIn() {
    setState(() {
      _zoom += 0.25;
    });
  }

  void zoomOut() {
    setState(() {
      _zoom = (_zoom - 0.25).clamp(0.5, 999);
    });
  }

  void resetZoom() {
    setState(() {
      _zoom = 1;
    });
  }

  void toggleExpansion() {
    setState(() {
      expanded = !expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle tabStyle = Theme.of(context).textTheme.subtitle1!.copyWith(
          color: context.theme.hintColor,
          fontWeight: FontWeight.bold,
        );

    inspect(widget.component);
    print(widget.component.toStringDeep());
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

    TransformationController _transformation = TransformationController();
    _transformation.value = Matrix4.identity()..scale(zoom);
    return FutureBuilder(
        future: loadAsset(context),
        builder: (BuildContext context, AsyncSnapshot<String> text) {
          return Expanded(
            child: Markdown(
              controller: controller,
              data: text.data ?? _markdownData,
            ),
          );
        });
  }
}

Future<String> loadAsset(context) async {
  return await rootBundle
      .loadString('lib/doc/test_component/TestComponent/TestComponent.md');
}
