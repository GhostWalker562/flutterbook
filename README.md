<img src="https://i.imgur.com/MiGH9tW.png" alt="Flutterbook" />

# Flutterbook

A storyboarding tool to accelerate the development of Flutter widgets. Inspired by Storybook.js.

**The package is built to support Windows and Web layouts. There is no support for mobile support at the moment. This is new and still under heavy development, expect many changes to occur with usage.**

<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>

---

Go subscribe to my YouTube channel to support development.

# [![MOONSDONTBURN Header](https://i.imgur.com/1QHjcUZ.png)](https://www.youtube.com/channel/UCurQRmT17EyOIrdPseiastg)

## Overview ✨

#### Creating the Main

Start by creating the storyboard widget. This will wrap the Flutterbook widget
so that when it is edited, it will hot reload.

```dart
class Storyboard extends StatelessWidget {
  const Storyboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterBook(
      categories: [
          // organizers ...
      ],
    );
  }
}
```

After creating the Storyboard widget, you can run it by using the main. I recommend making another
file named `main_storyboard.dart` to maintain your storyboard.

```dart
void main() {
  runApp(const Storyboard());
}
// Or run it directly, but this will cost the hot reload.
// void main() {
//   runApp(const Flutterbook(categories:[...]));
// }
```

#### How to add Widgets

To add widgets, you simply put `Organizers`, aka `Category`, `Folder`, `Component`, and `ComponentState`.

The hierarchy goes

`Category` > `Folder` > `Component` > `ComponentState`

but you may also do

`Category` > `Component` > `ComponentState`

or

`Category` > `Folder` > `Folder` > `Component` > `ComponentState`

Here is a complex example of a single `Category`. In the example, we use the builder
where we are able to access different controls.

```dart
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
    ],
),
```

### Demo
<a href="https://flutterbook.vercel.app/#/" target="_blank">Demo Link Here</a>

#### That's it!

## Roadmap 🚧
- [ ] Mobile Support
- [ ] 100% Code Coverage Testing
- [X ] Documentation Support in ComponentState's
- [ ] Better Docs
- [X ] Device Previews
- [ ] Shareable Handoffs
- [ ] Optimization

## Contributors 🔥
_Your name could be here_ 😉

<a href="https://github.com/GhostWalker562/flutterbook/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=GhostWalker562/flutterbook" />
</a>
