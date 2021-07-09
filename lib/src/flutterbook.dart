import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/core.dart';
import 'navigation/navigation.dart';
import 'routing/router.dart';
import 'styled_widgets/styled_widgets.dart';
import 'theme_provider.dart';
import 'utils/utils.dart';

class FlutterBook extends StatefulWidget {
  final List<Category> categories;
  final ThemeData? theme;
  final ThemeData? darkTheme;

  const FlutterBook({
    required this.categories,
    this.theme,
    this.darkTheme,
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
