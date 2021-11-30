// Code inpsired by https://github.com/samuelematias/flutter-design-system
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutterbook/src/utils/extensions.dart';

class CopyText extends StatelessWidget {
  final String textCopied;
  final String textTooltip;

  const CopyText({
    required this.textCopied,
    required this.textTooltip,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => _onTap(context),
      child: Tooltip(
        message: textTooltip,
        child: Icon(
          FeatherIcons.paperclip,
          color: context.theme.hintColor,
          size: 16,
        ),
      ),
    );
  }

  void _onTap(BuildContext context) {
    Clipboard.setData(
      ClipboardData(text: textCopied),
    );
    _showSnackBar(context);
  }

  void _showSnackBar(BuildContext context) =>
      Scaffold.of(context).showSnackBar(SnackBar(
        action: SnackBarAction(label: 'Close', onPressed: () {}),
        content: Text('Copied!'),
      ));
}
