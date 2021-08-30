import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../editor/editor.dart';
import '../navigation/models/organizers.dart';
import '../navigation/navigation.dart';
import 'story_provider.dart';

ModalRoute<void> generateRoute(
  BuildContext context,
  String? name, {
  RouteSettings? settings,
}) {
  ChangeNotifierProvider<StoryProvider> builder(context) {
    return ChangeNotifierProvider<StoryProvider>(
      create: (context) {
        final provider = StoryProvider.fromPath(
            name, recursiveRetrievalOfStates(context.read<List<Category>>()));
        context.read<CanvasDelegateProvider>().storyProvider = provider;
        return provider;
      },
      child: Builder(
        builder: (context) => const Editor(component: Story()),
      ),
    );
  }

  return StoryRoute(settings: settings, builder: builder);
}

class StoryRoute extends PopupRoute<void> {
  StoryRoute({
    required this.builder,
    RouteSettings? settings,
  }) : super(settings: settings);

  final WidgetBuilder builder;

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) =>
      builder(context);

  @override
  Duration get transitionDuration => const Duration();
}

List<ComponentState> recursiveRetrievalOfStates(List<Organizer> organizers) {
  final List<ComponentState> states = [];
  for (final Organizer current in organizers) {
    if (current is Component) {
      states.addAll(current.states);
    } else {
      states.addAll(recursiveRetrievalOfStates(current.organizers));
    }
  }
  return states;
}
