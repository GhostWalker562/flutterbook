import 'package:dart_code_viewer2/dart_code_viewer2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final String noCodeProvided = r'''/// No code provided''';

class CodeSampleThemeData {
  final TextStyle? baseStyle;
  final TextStyle? classStyle;
  final TextStyle? commentStyle;
  final TextStyle? constantStyle;
  final TextStyle? keywordStyle;
  final TextStyle? numberStyle;
  final TextStyle? punctuationStyle;
  final TextStyle? stringStyle;
  final Color? backgroundColor;

  CodeSampleThemeData({
    this.baseStyle,
    this.classStyle,
    this.commentStyle,
    this.constantStyle,
    this.keywordStyle,
    this.numberStyle,
    this.punctuationStyle,
    this.stringStyle,
    this.backgroundColor,
  });
}

class DocCodeSample extends StatelessWidget {
  final String? code;
  final CodeSampleThemeData? themeData;

  const DocCodeSample({
    Key? key,
    this.code,
    this.themeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "Copy Code Snippet",
      child: GestureDetector(
        onTap: () {
          Clipboard.setData(new ClipboardData(text: code ?? ''));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Code copied to clipboard"),
            ),
          );
        },
        child: DartCodeViewer(
          '''\n${code ?? noCodeProvided}''',
          showCopyButton: false,
          baseStyle: themeData?.baseStyle,
          classStyle: themeData?.classStyle,
          commentStyle: themeData?.commentStyle,
          constantStyle: themeData?.constantStyle,
          keywordStyle: themeData?.keywordStyle,
          numberStyle: themeData?.numberStyle,
          punctuationStyle: themeData?.punctuationStyle,
          stringStyle: themeData?.stringStyle,
          backgroundColor: themeData?.backgroundColor,
        ),
      ),
    );
  }
}
