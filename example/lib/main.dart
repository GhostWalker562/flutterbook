import 'package:example/list_example.dart';
import 'package:example/themes.dart';
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
      themes: Themes.themes,
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
              componentMarkdown: """
## Component Markdown Example
The `Button` is global a component used for user actions.
               """,
              states: [
                ComponentState(
                  markdown: """
### Component State Markdown Example
The `Button.primary` is used for the main action to be performed.
               """,
                  codeSample: r'''
Button.primary(
  child: Text('Primary Button'),
  onPressed: () {},
);
''',
                  stateName: 'Primary',
                  builder: (context, c) {
                    return Center(
                      child: SizedBox(
                        width: c.number(
                          label: 'Number',
                          initial: 100,
                          min: 100,
                          max: 250,
                        ),
                        height: c.number(
                          label: 'height',
                          initial: 50,
                          min: 50,
                          max: 250,
                          description: 'random stuff',
                        ),
                        child: CupertinoButton(
                          color: c.list<Color>(
                            label: "Color",
                            initial: Colors.red,
                            value: Colors.red,
                            list: [
                              ListItem(title: "Red", value: Colors.red),
                              ListItem(title: "Blue", value: Colors.blue),
                              ListItem(title: "Black", value: Colors.black),
                              ListItem(title: "Amber", value: Colors.amber),
                            ],
                          ),
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
                ComponentState(
                  markdown: """
### Component State Markdown Example
The `Button.secondary` is used for user alternate actions.
               """,
                  codeSample: r'''
Button.secondary(
  child: Text('Primary Button'),
  onPressed: () {},
);
''',
                  stateName: 'Secondary',
                  builder: (context, c) {
                    return Center(
                      child: SizedBox(
                        width: c.number(
                          label: 'Number',
                          initial: 100,
                          min: 100,
                          max: 250,
                        ),
                        height: c.number(
                          label: 'height',
                          initial: 50,
                          min: 50,
                          max: 250,
                          description: 'random stuff',
                        ),
                        child: CupertinoButton(
                          onPressed: c.boolean(
                            label: 'boolean',
                            initial: true,
                          )
                              ? () {}
                              : null,
                          child: Text(
                            c.text(
                              label: 'Text',
                              initial: 'Hello World',
                            ),
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
                  codeSample: """ListExample()""",
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
