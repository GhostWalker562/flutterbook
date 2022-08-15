import 'package:flutter/material.dart';
import 'package:flutterbook/src/editor/ui/doc_component/doc_code_sample.dart';
import 'package:flutterbook/src/utils/utils.dart';

class CodeExpansionSection extends StatefulWidget {
  final String? code;

  CodeExpansionSection({Key? key, this.code}) : super(key: key);

  @override
  State<CodeExpansionSection> createState() => CodeExpansionSectionState();
}

class CodeExpansionSectionState extends State<CodeExpansionSection> {
  bool expanded = false;

  bool get noCodeAvailable => widget.code == null;

  void toggleExpansion() {
    setState(() {
      expanded = !expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return noCodeAvailable
        ? _NodeCodeContainer()
        : _CodeSection(
            code: widget.code!,
            isExpanded: expanded,
            onToggle: (_) => toggleExpansion(),
          );
  }
}

class _NodeCodeContainer extends StatelessWidget {
  const _NodeCodeContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: canvasRadius,
          ),
          color: Theme.of(context).shadowColor,
        ),
        padding: EdgeInsets.all(10),
        child: Text('No Code Available'),
      ),
    );
  }
}

class _CodeSection extends StatelessWidget {
  final String code;
  final bool isExpanded;
  final Function(bool) onToggle;

  const _CodeSection({
    Key? key,
    required this.code,
    required this.isExpanded,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        onExpansionChanged: onToggle,
        title: Text(isExpanded ? "Hide Code" : "Show Code"),
        children: <Widget>[
          if (isExpanded)
            Container(
              height: 400,
              child: DocCodeSample(code: code),
            )
          else
            SizedBox.shrink()
        ],
      ),
    );
  }
}
