import 'package:flutter/material.dart';
import '../../routing/story_provider.dart';

class CanvasDelegateProvider extends ChangeNotifier {
  CanvasDelegateProvider({
    StoryProvider? storyProvider,
  }) : _storyProvider = storyProvider;

  StoryProvider? _storyProvider;

  // ignore: unnecessary_getters_setters
  StoryProvider? get storyProvider => _storyProvider;

  set storyProvider(StoryProvider? provider) {
    _storyProvider = provider;
  }
}
