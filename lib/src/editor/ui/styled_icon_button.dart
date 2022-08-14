import 'package:flutter/material.dart';

class StyledTextButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onPressed;

  StyledTextButton({
    required this.icon,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(90),
          child: Icon(
            icon,
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).hintColor,
            size: 16,
          )),
    );
  }
}
