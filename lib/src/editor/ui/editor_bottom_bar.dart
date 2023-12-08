import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

import '../../routing/story_provider.dart';
import '../../styled_widgets/styled_widgets.dart';
import '../../utils/extensions.dart';

enum FlutterBookTab { controls, actions, none }

class CoreBottomBar extends StatefulWidget {
  const CoreBottomBar({Key? key}) : super(key: key);

  @override
  _CoreBottomBarState createState() => _CoreBottomBarState();
}

class _CoreBottomBarState extends State<CoreBottomBar> {
  FlutterBookTab tab = FlutterBookTab.none;

  bool get isOpen => tab != FlutterBookTab.none;

  void changeControls(FlutterBookTab tab) {
    if (this.tab == tab) {
      setState(() => this.tab = FlutterBookTab.none);
      return;
    }
    setState(() => this.tab = tab);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      curve: Curves.linearToEaseOut,
      duration: const Duration(milliseconds: 300),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _TabButton(
                currentTab: tab,
                onPressed: () => changeControls(FlutterBookTab.controls),
                tab: FlutterBookTab.controls,
                text: 'Controls',
              ),
              if (isOpen)
                TextButton(
                  onPressed: () => setState(() => tab = FlutterBookTab.none),
                  style: TextButton.styleFrom(
                    splashFactory: InkRipple.splashFactory,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90)),
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.all(12),
                  ),
                  child: Icon(
                    FeatherIcons.cornerRightDown,
                    color: context.theme.hintColor,
                    size: 16,
                  ),
                ),
            ],
          ),
          Divider(
            height: 0,
            color: context.theme.dividerColor.withOpacity(0.5),
          ),
          if (isOpen) const _BottomBarContent(),
        ],
      ),
    );
  }
}

class _BottomBarContent extends StatelessWidget {
  const _BottomBarContent({Key? key}) : super(key: key);

  Widget builderHeaders(BuildContext context) {
    final headerTextStyle = context.textTheme.titleSmall!.copyWith(
      fontWeight: FontWeight.w600,
      color: context.colorScheme.onSurface.withOpacity(0.5),
    );

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            'Name',
            style: headerTextStyle,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'Description',
            style: headerTextStyle,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'Default',
            style: headerTextStyle,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'Controls',
            style: headerTextStyle,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StoryProvider>(
      builder: (BuildContext context, StoryProvider value, Widget? child) {
        return Unfocuser(
          child: SizedBox(
            height: 300,
            width: double.infinity,
            child: ListView.separated(
              itemCount: value.all.length + 1,
              itemBuilder: (context, index) {
                late Widget current;
                if (index == 0) {
                  current = builderHeaders(context);
                } else {
                  current = value.all[index - 1].build();
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24),
                  child: current,
                );
              },
              separatorBuilder: (context, index) => Divider(
                height: 0,
                color: context.theme.dividerColor.withOpacity(0.1),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.tab,
    required this.currentTab,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;
  final FlutterBookTab tab;
  final FlutterBookTab currentTab;

  @override
  Widget build(BuildContext context) {
    final TextStyle selectedTabStyle = context.textTheme.titleMedium!.copyWith(
      fontWeight: FontWeight.bold,
      color: context.colorScheme.primary,
    );

    final TextStyle tabStyle = context.textTheme.titleMedium!.copyWith(
      fontWeight: FontWeight.bold,
      color: context.theme.hintColor,
    );

    return TextButton(
      onPressed: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: context.colorScheme.primary,
              style: currentTab == tab ? BorderStyle.solid : BorderStyle.none,
              width: 3,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        child: Text(
          text,
          style: currentTab == tab ? selectedTabStyle : tabStyle,
        ),
      ),
    );
  }
}
