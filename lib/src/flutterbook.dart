import 'package:flutter/material.dart';
import 'package:flutterbook/src/editor/providers/device_preview_provider.dart';
import 'package:flutterbook/src/editor/providers/pan_provider.dart';
import 'package:flutterbook/src/editor/providers/tab_provider.dart';
import 'package:flutterbook/src/utils/flutter_book_theme.dart';
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

  /// Custom theme for the code sample shown on component state documentation.
  final CodeSampleThemeData? codeSampleTheme;

  /// This is used for projects that have more than two themes, if it is defined
  /// and not empty, then the `theme` and `darkTheme` will be ignored and a
  /// dropdown will appear in the editor tabs.
  final List<FlutterBookTheme>? themes;

  final Locale? locale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final LocaleListResolutionCallback? localeListResolutionCallback;
  final LocaleResolutionCallback? localeResolutionCallback;
  final Iterable<Locale>? supportedLocales;

  const FlutterBook({
    Key? key,
    required this.categories,
    this.theme,
    this.darkTheme,
    this.codeSampleTheme,
    this.header,
    this.headerPadding = const EdgeInsets.fromLTRB(20, 16, 20, 8),
    this.themes,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales,
  }) : super(key: key);

  @override
  _FlutterBookState createState() => _FlutterBookState();
}

class _FlutterBookState extends State<FlutterBook> {
  GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();
  Widget? selectedComponent;

  bool get useMultiTheme => widget.themes != null && widget.themes!.length > 1;
  List<String> get themeNames =>
      widget.themes?.map((theme) => theme.themeName).toList() ?? [];

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
        ChangeNotifierProvider(create: (_) => CanvasDelegateProvider()),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(
            useListOfThemes: useMultiTheme,
            themeNames: themeNames,
          ),
        ),
        ChangeNotifierProvider(create: (_) => DevicePreviewProvider()),
        ChangeNotifierProvider(create: (_) => GridProvider()),
        ChangeNotifierProvider(create: (_) => TabProvider()),
        ChangeNotifierProvider(create: (_) => ZoomProvider()),
        ChangeNotifierProvider(create: (_) => PanProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (BuildContext context, model, Widget? child) {
          ThemeData activeTheme = useMultiTheme
              ? widget.themes![model.activeThemeIndex].theme
              : widget.theme ?? Styles().theme;

          return MaterialApp(
            title: 'Flutterbook',
            debugShowCheckedModeBanner: false,
            theme: activeTheme,
            locale: widget.locale,
            localizationsDelegates: widget.localizationsDelegates,
            localeListResolutionCallback: widget.localeListResolutionCallback,
            localeResolutionCallback: widget.localeResolutionCallback,
            supportedLocales:
            widget.supportedLocales ?? const <Locale>[Locale('en', 'US')],
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
