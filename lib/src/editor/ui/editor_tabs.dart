import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutterbook/src/editor/editor.dart';
import 'package:flutterbook/src/editor/providers/device_preview_provider.dart';
import 'package:flutterbook/src/editor/ui/styled_icon_button.dart';
import 'package:provider/provider.dart';

import '../../theme_provider.dart';
import '../../utils/extensions.dart';
import '../providers/zoom_provider.dart';

enum FlutterBookTab { canvas, docs }

class CoreContentTabs extends StatefulWidget {
  const CoreContentTabs({Key? key}) : super(key: key);

  @override
  _CoreContentTabsState createState() => _CoreContentTabsState();
}

class _CoreContentTabsState extends State<CoreContentTabs> {
  FlutterBookTab tab = FlutterBookTab.canvas;

  @override
  Widget build(BuildContext context) {
    final TextStyle selectedTabStyle = context.textTheme.subtitle1!.copyWith(
      fontWeight: FontWeight.bold,
      color: context.colorScheme.primary,
    );

    final TextStyle tabStyle = context.textTheme.subtitle1!.copyWith(
      fontWeight: FontWeight.bold,
      color: context.theme.hintColor,
    );

    return IntrinsicHeight(
      child: Row(
        children: [
          TextButton(
            onPressed: () => setState(() => tab = FlutterBookTab.canvas),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: context.colorScheme.primary,
                    style: tab == FlutterBookTab.canvas
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
                style:
                    tab == FlutterBookTab.canvas ? selectedTabStyle : tabStyle,
              ),
            ),
          ),
          TextButton(
            onPressed: () => setState(() => tab = FlutterBookTab.docs),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: context.colorScheme.primary,
                    style: tab == FlutterBookTab.docs
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
                style: tab == FlutterBookTab.docs ? selectedTabStyle : tabStyle,
              ),
            ),
          ),
          const TabsVerticalDivider(),
          StyledIconButton(
            onPressed: context.read<ZoomProvider>().zoomIn,
            icon: FeatherIcons.zoomIn,
          ),
          const SizedBox(width: 8),
          StyledIconButton(
            onPressed: context.read<ZoomProvider>().zoomOut,
            icon: FeatherIcons.zoomOut,
          ),
          const SizedBox(width: 8),
          StyledIconButton(
            onPressed: context.read<ZoomProvider>().resetZoom,
            icon: FeatherIcons.refreshCcw,
          ),
          StyledIconButton(
            onPressed: context.read<GridProvider>().toggleGrid,
            icon: FeatherIcons.grid,
          ),
          const TabsVerticalDivider(),
          const SizedBox(width: 8),
          StyledIconButton(
            onPressed: context.read<DarkThemeProvider>().toggleDarkTheme,
            icon: FeatherIcons.moon,
          ),
          const SizedBox(width: 8),
          StyledIconButton(
            onPressed: context.read<DevicePreviewProvider>().togglePreview,
            icon: FeatherIcons.smartphone,
          ),
        ],
      ),
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
