import 'package:flutter/material.dart';
import 'package:flutterbook/src/utils/extensions.dart';

class StyledTextButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  StyledTextButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(90),
        child: Icon(
          icon,
          color: context.theme.hintColor,
          size: 16,
        ));
  }
}
