import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutterbook/src/editor/ui/styled_icon_button.dart';
import 'package:flutterbook/src/utils/extensions.dart';
import 'package:flutterbook/src/utils/radii.dart';

class DocPanel extends StatefulWidget {
  final Widget component;
  const DocPanel({
    Key? key,
    required this.component,
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
    TransformationController _transformation = TransformationController();
    _transformation.value = Matrix4.identity()..scale(zoom);
    return Container(
      width: 900,
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
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  StyledIconButton(
                    onPressed: zoomIn,
                    icon: FeatherIcons.zoomIn,
                  ),
                  const SizedBox(width: 8),
                  StyledIconButton(
                    onPressed: zoomOut,
                    icon: FeatherIcons.zoomOut,
                  ),
                  const SizedBox(width: 8),
                  StyledIconButton(
                    onPressed: resetZoom,
                    icon: FeatherIcons.refreshCcw,
                  ),
                ],
              ),
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
                  child: widget.component),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: TextButton(
                child: Text(expanded ? "Show Code" : "Hide Code"),
                onPressed: toggleExpansion,
              ),
            ),
            expanded
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          color: context.theme.shadowColor.withOpacity(0.075),
                        ),
                      ],
                      borderRadius: canvasBorderRadius,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
