import 'package:flutter/material.dart';
import 'package:flutterbook/src/utils/extensions.dart';

class StyledIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  StyledIconButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          splashFactory: InkRipple.splashFactory,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),
          minimumSize: Size.zero,
          padding: const EdgeInsets.all(12),
        ),
        child: Icon(
          icon,
          color: context.theme.hintColor,
          size: 16,
        ));
  }
}
