import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutterbook/src/editor/providers/device_preview_provider.dart';
import 'package:provider/provider.dart';

import '../../theme_provider.dart';
import '../../utils/extensions.dart';
import '../../utils/styles.dart' show Styles;
import '../providers/grid_provider.dart';
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
          const _TabsVerticalDivider(),
          TextButton(
            onPressed: context.read<ZoomProvider>().zoomIn,
            style: TextButton.styleFrom(
              splashFactory: InkRipple.splashFactory,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(90)),
              minimumSize: Size.zero,
              padding: const EdgeInsets.all(12),
            ),
            child: Icon(
              FeatherIcons.zoomIn,
              color: context.theme.hintColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: context.read<ZoomProvider>().zoomOut,
            style: TextButton.styleFrom(
              splashFactory: InkRipple.splashFactory,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(90)),
              minimumSize: Size.zero,
              padding: const EdgeInsets.all(12),
            ),
            child: Icon(
              FeatherIcons.zoomOut,
              color: context.theme.hintColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: context.read<ZoomProvider>().resetZoom,
            style: TextButton.styleFrom(
              splashFactory: InkRipple.splashFactory,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(90)),
              minimumSize: Size.zero,
              padding: const EdgeInsets.all(12),
            ),
            child: Icon(
              FeatherIcons.refreshCcw,
              color: context.theme.hintColor,
              size: 16,
            ),
          ),
          const _TabsVerticalDivider(),
          TextButton(
            onPressed: context.read<GridProvider>().toggleGrid,
            style: TextButton.styleFrom(
              splashFactory: InkRipple.splashFactory,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(90)),
              minimumSize: Size.zero,
              padding: const EdgeInsets.all(12),
            ),
            child: Consumer<GridProvider>(
              builder: (context, model, child) {
                return Icon(
                  FeatherIcons.grid,
                  color: model.grid
                      ? context.colorScheme.primary
                      : context.theme.hintColor,
                  size: 16,
                );
              },
            ),
          ),
          TextButton(
            onPressed: context.read<DarkThemeProvider>().toggleDarkTheme,
            style: TextButton.styleFrom(
              splashFactory: InkRipple.splashFactory,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(90)),
              minimumSize: Size.zero,
              padding: const EdgeInsets.all(12),
            ),
            child: Consumer<DarkThemeProvider>(
              builder: (context, model, child) {
                return Icon(
                  FeatherIcons.moon,
                  color: Styles.isDark
                      ? context.colorScheme.primary
                      : context.theme.hintColor,
                  size: 16,
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: context.read<DevicePreviewProvider>().togglePreview,
            style: TextButton.styleFrom(
              splashFactory: InkRipple.splashFactory,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(90)),
              minimumSize: Size.zero,
              padding: const EdgeInsets.all(12),
            ),
            child: Consumer<DarkThemeProvider>(
              builder: (context, model, child) {
                return Icon(
                  FeatherIcons.smartphone,
                  color: Styles.isDark
                      ? context.colorScheme.primary
                      : context.theme.hintColor,
                  size: 16,
                );
              },
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _TabsVerticalDivider extends StatelessWidget {
  const _TabsVerticalDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
      indent: 10,
      endIndent: 10,
      color: context.theme.dividerColor.withOpacity(0.5),
    );
  }
}
