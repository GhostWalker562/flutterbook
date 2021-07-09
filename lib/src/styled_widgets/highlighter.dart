import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/utils.dart';

class Highlighter extends StatefulWidget {
  const Highlighter({
    Key? key,
    required this.child,
    this.color,
    this.onPressed,
    this.onEnter,
    this.onExit,
    this.cursor,
    this.overrideHover = false,
  }) : super(key: key);

  final Widget child;
  final Color? color;
  final VoidCallback? onPressed;
  final PointerEnterEventListener? onEnter;
  final PointerExitEventListener? onExit;
  final MouseCursor? cursor;
  final bool overrideHover;

  @override
  _HighlighterState createState() => _HighlighterState();
}

class _HighlighterState extends State<Highlighter> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: MouseRegion(
        onEnter: (e) {
          widget.onEnter?.call(e);
          setState(() => hovered = true);
        },
        onExit: (e) {
          widget.onExit?.call(e);
          setState(() => hovered = false);
        },
        cursor: widget.cursor ?? SystemMouseCursors.click,
        child: AnimatedContainer(
          decoration: BoxDecoration(
            color: widget.overrideHover || hovered
                ? widget.color ?? context.colorScheme.primary
                : null,
            // borderRadius: mainBorderRadius,
          ),
          duration: const Duration(milliseconds: 100),
          child: widget.child,
        ),
      ),
    );
  }
}
