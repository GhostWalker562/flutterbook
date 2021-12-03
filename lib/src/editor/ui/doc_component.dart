import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutterbook/src/editor/ui/doc_markdown.dart';
import 'package:flutterbook/src/editor/ui/styled_icon_button.dart';
import 'package:flutterbook/src/utils/extensions.dart';
import 'package:flutterbook/src/utils/radii.dart';

class DocPanel extends StatefulWidget {
  final Widget component;
  final String? docPath;
  final String stateName;

  const DocPanel({
    Key? key,
    required this.component,
    this.docPath,
    required this.stateName,
  }) : super(key: key);

  @override
  _DocPanelState createState() => _DocPanelState();
}

class _DocPanelState extends State<DocPanel> {
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
          fontWeight: FontWeight.bold,
          color: context.theme.hintColor,
        );

    TransformationController _transformation = TransformationController();
    _transformation.value = Matrix4.identity()..scale(zoom);
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: context.theme.shadowColor.withOpacity(0.075),
          ),
        ],
        borderRadius: canvasBorderRadius,
        color: context.colorScheme.surface,
      ),
      margin: const EdgeInsets.fromLTRB(0, 12, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(widget.stateName, style: tabStyle),
              ),
              VerticalDivider(),
              StyledTextButton(
                onPressed: zoomIn,
                icon: FeatherIcons.zoomIn,
              ),
              const SizedBox(width: 8),
              StyledTextButton(
                onPressed: zoomOut,
                icon: FeatherIcons.zoomOut,
              ),
              const SizedBox(width: 8),
              StyledTextButton(
                onPressed: resetZoom,
                icon: FeatherIcons.refreshCcw,
              ),
            ],
          ),
          Divider(
            height: 0,
            color: context.theme.dividerColor.withOpacity(0.5),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: InteractiveViewer(
              panEnabled: true,
              boundaryMargin: EdgeInsets.all(double.infinity),
              transformationController: _transformation,
              child: widget.component,
            ),
          ),
          Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExpansionTile(
                    title: Text(expanded ? "Hide Code" : "Show Code"),
                    onExpansionChanged: (bool e) {
                      setState(() => expanded = e);
                    },
                    children: <Widget>[
                      expanded
                          ? SizedBox(
                              height: 400,
                              child: DocMarkDown(docPath: widget.docPath),
                            )
                          : SizedBox.shrink()
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
