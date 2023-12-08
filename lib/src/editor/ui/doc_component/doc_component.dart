import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutterbook/src/editor/ui/doc_component/code_expansion_section.dart';
import 'package:flutterbook/src/editor/ui/doc_markdown.dart';
import 'package:flutterbook/src/editor/ui/styled_icon_button.dart';
import 'package:flutterbook/src/utils/extensions.dart';
import 'package:flutterbook/src/utils/radii.dart';

class DocPanel extends StatelessWidget {
  final Widget component;
  final String? markdown;
  final String? codeSample;
  final String stateName;

  const DocPanel({
    Key? key,
    this.codeSample,
    required this.component,
    this.markdown,
    required this.stateName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle =
        Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).hintColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(stateName, style: titleStyle),
        ),
        CanvasPreview(
          component: component,
          codeSample: codeSample,
        ),
        if (markdown != null)
          DocMarkDown(
            markdown: markdown,
          ),
      ],
    );
  }
}

class CanvasPreview extends StatefulWidget {
  final Widget component;
  final String? codeSample;

  const CanvasPreview({
    Key? key,
    this.codeSample,
    required this.component,
  }) : super(key: key);

  @override
  State<CanvasPreview> createState() => _CanvasPreviewState();
}

class _CanvasPreviewState extends State<CanvasPreview> {
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

  @override
  Widget build(BuildContext context) {
    TransformationController _transformation = TransformationController();
    _transformation.value = Matrix4.identity()..scale(zoom);
    return Container(
      decoration: BoxDecoration(
        borderRadius: canvasBorderRadius,
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: context.theme.shadowColor.withOpacity(0.075),
          ),
        ],
        color: context.colorScheme.surface,
      ),
      margin: const EdgeInsets.fromLTRB(0, 12, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              VerticalDivider(),
              StyledTextButton(
                icon: FeatherIcons.zoomIn,
                onPressed: zoomIn,
              ),
              const SizedBox(width: 8),
              StyledTextButton(
                icon: FeatherIcons.zoomOut,
                onPressed: zoomOut,
              ),
              const SizedBox(width: 8),
              StyledTextButton(
                icon: FeatherIcons.refreshCcw,
                onPressed: resetZoom,
              ),
            ],
          ),
          Divider(
            color: context.theme.dividerColor.withOpacity(0.5),
            height: 0,
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: InteractiveViewer(
              boundaryMargin: EdgeInsets.all(double.infinity),
              panEnabled: true,
              transformationController: _transformation,
              child: widget.component,
            ),
          ),
          CodeExpansionSection(code: widget.codeSample),
        ],
      ),
    );
  }
}
