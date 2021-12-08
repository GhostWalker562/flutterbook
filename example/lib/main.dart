import 'package:example/list_example.dart';
import 'package:example/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterbook/flutterbook.dart';

void main() {
  runApp(const Storyboard());
}

class Storyboard extends StatelessWidget {
  const Storyboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterBook(
      categories: [
        Category(
          categoryName: 'LIBRARY',
          organizers: [
            Folder(
              folderName: 'Charts',
              organizers: [
                Component(
                  componentName: 'LineGraph',
                  states: [
                    ComponentState.child(
                      stateName: 'Default Container',
                      child: Container(),
                    ),
                  ],
                ),
              ],
            ),
            Component(
              componentName: 'Button',
              states: [
                ComponentState(
                  markdown: Future<String>.value("""Dart Doc Example"""),
                  stateName: 'Primary',
                  builder: (context, c) {
                    return Center(
                      child: SizedBox(
                        width: c.number(
                          label: 'Number',
                          initial: 50,
                          min: 50,
                          max: 250,
                        ),
                        height: c.number(
                          label: 'height',
                          initial: 50,
                          min: 50,
                          max: 250,
                          description: 'random stuff',
                        ),
                        child: CupertinoButton.filled(
                          onPressed: c.boolean(
                            label: 'boolean',
                            initial: true,
                          )
                              ? () {}
                              : null,
                          child: Text(
                            c.text(label: 'Text', initial: 'Hello World'),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            Component(
              componentName: 'List',
              states: [
                ComponentState(
                  markdown: FileReader().getContents('lib/assets/list_example'),
                  stateName: 'Primary',
                  builder: (context, c) => ListExample(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
