
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
                  docs: '''
                    Button(onPressed: () {}, label: 'hello');
                  ''',
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
                ComponentState(
                  docs: '''
                    IconButton(onPressed: () {}, icon: Icon())
                  ''',
                  stateName: 'Secondary',
                  builder: (context, c) {
                    return Center(
                        child: IconButton(
                      icon: Icon(Icons.smartphone),
                      onPressed: () {},
                    ));
                  },
                ),
              ],
            ),
            Component(
              componentName: 'List',
              states: [
                ComponentState(
                  stateName: 'Primary',
                  builder: (context, c) {
                    return Container(
                      width: 400,
                      height: 400,
                      color: Colors.white,
                      child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (_, i) => Container(
                          width: 400,
                          height: 100,
                          color: (i % 2 == 0) ? Colors.red : Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
