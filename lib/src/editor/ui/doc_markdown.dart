import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:recase/recase.dart';

class DocMarkDown extends StatefulWidget {
  final String? docName;

  const DocMarkDown({
    Key? key,
    this.docName,
  }) : super(key: key);

  @override
  _DocMarkDownState createState() => _DocMarkDownState();
}

class _DocMarkDownState extends State<DocMarkDown> {
  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();
    const String _markdownData = """
## Could Not Find Doc For Documents

If you are seeing this message, that means you have not generated docs for this component

### Create Docs For Component
 - add the latest version of dartdoc to your pubspec.yaml
 The --input is the path to your root directory in your project
 The --output is the path in your project where the assets need to stay
 - run dartdoc --format md --input "my_fake_project" --output "my_fake_project/assets/lib/docs"
 - create a component and add it to your component state with a attribute ***docName***
""";

    return FutureBuilder(
      future: loadAsset(context, widget.docName),
      initialData: _markdownData,
      builder: (BuildContext context, AsyncSnapshot<String> text) {
        return Tooltip(
          message: "Click To Copy",
          child: Markdown(
            selectable: true,
            controller: controller,
            data: text.data ?? _markdownData,
            shrinkWrap: true,
            extensionSet: md.ExtensionSet(
              md.ExtensionSet.gitHubFlavored.blockSyntaxes,
              [
                md.EmojiSyntax(),
                ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
              ],
            ),
            onTapText: () => {
              Clipboard.setData(ClipboardData(text: text.data ?? "")).then(
                  (value) => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Copied to your clipboard !'))))
            },
          ),
        );
      },
    );
  }
}

Future<String> loadAsset(context, docName) async {
  ReCase doc = new ReCase(docName);
  final docNameSnake = doc.snakeCase;
  return await rootBundle.loadString("doc/$docNameSnake/$docName/$docName.md");
}
