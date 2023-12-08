import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutterbook/src/editor/editor.dart';
import 'package:flutterbook/src/editor/providers/device_preview_provider.dart';
import 'package:flutterbook/src/editor/providers/pan_provider.dart';
import 'package:flutterbook/src/editor/providers/tab_provider.dart';
import 'package:flutterbook/src/editor/ui/styled_icon_button.dart';
import 'package:provider/provider.dart';

import '../../theme_provider.dart';
import '../../utils/extensions.dart';

enum FlutterBookTab { canvas, docs }

class CoreContentTabs extends StatefulWidget {
  const CoreContentTabs({Key? key}) : super(key: key);

  @override
  _CoreContentTabsState createState() => _CoreContentTabsState();
}

class _CoreContentTabsState extends State<CoreContentTabs> {
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

    return IntrinsicHeight(
      child: Row(
        children: [
          TextButton(
            onPressed: () => Provider.of<TabProvider>(
              context,
              listen: false,
            ).setTab(FlutterBookTab.canvas),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: context.colorScheme.primary,
                    style: context.watch<TabProvider>().tab ==
                            FlutterBookTab.canvas
                        ? BorderStyle.solid
                        : BorderStyle.none,
                    width: 3,
                  ),
                ),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              child: Text(
                'Canvas',
                style: context.read<TabProvider>().tab == FlutterBookTab.canvas
                    ? selectedTabStyle
                    : tabStyle,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Provider.of<TabProvider>(
              context,
              listen: false,
            ).setTab(FlutterBookTab.docs),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: context.colorScheme.primary,
                    style:
                        context.watch<TabProvider>().tab == FlutterBookTab.docs
                            ? BorderStyle.solid
                            : BorderStyle.none,
                    width: 3,
                  ),
                ),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              child: Text(
                'Docs',
                style: context.read<TabProvider>().tab == FlutterBookTab.docs
                    ? selectedTabStyle
                    : tabStyle,
              ),
            ),
          ),
          const TabsVerticalDivider(),
          if (context.read<TabProvider>().tab == FlutterBookTab.canvas)
            _CanvasTabs(),
          if (!context.watch<ThemeProvider>().isUsingListOfThemes)
            StyledTextButton(
              icon: FeatherIcons.moon,
              onPressed: context.read<ThemeProvider>().toggleDarkTheme,
            ),
          if (context.watch<ThemeProvider>().isUsingListOfThemes)
            _MultiThemeDropdownButton(),
        ],
      ),
    );
  }
}

class ThemeItem {
  final String name;
  final int index;
  ThemeItem({required this.name, required this.index});
}

class _MultiThemeDropdownButton extends StatelessWidget {
  const _MultiThemeDropdownButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<ThemeItem>> themeItems = context
        .watch<ThemeProvider>()
        .themeNames
        .asMap()
        .map((index, name) {
          return MapEntry(
            index,
            DropdownMenuItem<ThemeItem>(
              value: ThemeItem(name: name, index: index),
              child: Text(name),
            ),
          );
        })
        .values
        .toList();

    return DropdownButton<ThemeItem>(
      items: themeItems,
      dropdownColor: Theme.of(context).scaffoldBackgroundColor,
      value: themeItems[context.watch<ThemeProvider>().activeThemeIndex].value,
      onChanged: (ThemeItem? item) {
        if (item != null) {
          context.read<ThemeProvider>().onChangeActiveThemeIndex(item.index);
        }
      },
    );
  }
}

class _CanvasTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const _spacer = const SizedBox(width: 8);
    return Row(
      children: [
        StyledTextButton(
          icon: FeatherIcons.mousePointer,
          isActive: context.watch<PanProvider>().panEnabled,
          onPressed: context.read<PanProvider>().toggle,
        ),
        StyledTextButton(
          icon: FeatherIcons.zoomIn,
          onPressed: context.read<ZoomProvider>().zoomIn,
        ),
        _spacer,
        StyledTextButton(
          icon: FeatherIcons.zoomOut,
          onPressed: context.read<ZoomProvider>().zoomOut,
        ),
        _spacer,
        StyledTextButton(
          icon: FeatherIcons.refreshCcw,
          onPressed: context.read<ZoomProvider>().resetZoom,
        ),
        StyledTextButton(
          icon: FeatherIcons.grid,
          isActive: context.watch<GridProvider>().grid,
          onPressed: context.read<GridProvider>().toggleGrid,
        ),
        const TabsVerticalDivider(),
        _spacer,
        StyledTextButton(
          icon: FeatherIcons.smartphone,
          isActive: context.watch<DevicePreviewProvider>().show,
          onPressed: context.read<DevicePreviewProvider>().togglePreview,
        ),
        _spacer,
      ],
    );
  }
}

class TabsVerticalDivider extends StatelessWidget {
  const TabsVerticalDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
      indent: 10,
      endIndent: 10,
      color: context.theme.dividerColor.withOpacity(0.5),
    );
  }
}
