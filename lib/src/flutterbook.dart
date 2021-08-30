import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'editor/editor.dart';
import 'navigation/navigation.dart';
import 'routing/router.dart';
import 'styled_widgets/styled_widgets.dart';
import 'theme_provider.dart';
import 'utils/utils.dart';

class FlutterBook extends StatefulWidget {
  /// Categories that can contain folders or components that can display states.
  /// States will have widgets which you may click on and display the widget in
  /// the editor.
  final List<Category> categories;

  /// The `ThemeData` that is defaulted when the project is opened. This should
  /// be considered as the light theme.
  final ThemeData? theme;

  /// The `ThemeData` used when the dark theme is enabled.
  final ThemeData? darkTheme;

  /// The branding/header of the project. This is displayed on the top left of the
  /// flutterbook.
  final Widget? header;

  /// The padding for the branding/header of the project.
  final EdgeInsetsGeometry headerPadding;

  const FlutterBook({
    required this.categories,
    this.theme,
    this.darkTheme,
    this.header,
    this.headerPadding = const EdgeInsets.fromLTRB(20, 16, 20, 8),
  });

  @override
  _FlutterBookState createState() => _FlutterBookState();
}

class _FlutterBookState extends State<FlutterBook> {
  GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();
  Widget? selectedComponent;

  @override
  void initState() {
    if (widget.darkTheme != null) Styles.darkTheme = widget.darkTheme!;
    if (widget.theme != null) Styles.lightTheme = widget.theme!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: widget.categories),
        ChangeNotifierProvider(create: (_) => DarkThemeProvider()),
        ChangeNotifierProvider(create: (_) => GridProvider()),
        ChangeNotifierProvider(create: (_) => ZoomProvider()),
        ChangeNotifierProvider(create: (_) => CanvasDelegateProvider()),
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, model, Widget? child) {
          return MaterialApp(
            title: 'Flutterbook',
            debugShowCheckedModeBanner: false,
            theme: Styles().theme,
            builder: (context, child) {
              return StyledScaffold(
                body: Row(
                  children: [
                    NavigationPanel(
                      header: widget.header,
                      headerPadding: widget.headerPadding,
                      categories: context.watch<List<Category>>().toList(),
                      onComponentSelected: (child) {
                        navigator.currentState!.pushReplacementNamed(
                            '/stories/${child?.path ?? ''}');
                        context
                            .read<CanvasDelegateProvider>()
                            .storyProvider!
                            .updateStory(child);
                      },
                    ),
                    Expanded(
                      child: Navigator(
                        reportsRouteUpdateToEngine: true,
                        key: navigator,
                        initialRoute: '/',
                        onGenerateRoute: (settings) => generateRoute(
                          context,
                          settings.name,
                          settings: settings,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
