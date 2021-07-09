import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../routing/story_provider.dart';
import '../../utils/utils.dart';
import '../providers/canvas_delegate.dart';
import '../providers/grid_provider.dart';
import '../providers/zoom_provider.dart';
import 'bottom_bar.dart';
import 'tabs.dart';

class CoreContentWrapper extends StatelessWidget {
  const CoreContentWrapper({Key? key, required this.component})
      : super(key: key);

  final Widget? component;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: context.theme.shadowColor.withOpacity(0.075),
          ),
        ],
        borderRadius: canvasBorderRadius,
        color: context.colorScheme.surface,
      ),
      margin: const EdgeInsets.fromLTRB(0, 12, 12, 12),
      child: ClipRRect(
        borderRadius: canvasBorderRadius,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: CoreContentTabs(),
            ),
            Divider(
              height: 0,
              color: context.theme.dividerColor.withOpacity(0.5),
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Consumer<GridProvider>(
                      builder: (context, model, child) {
                        return model.grid
                            ? GridPaper(
                                color: context.theme.canvasColor,
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                  ),
                  Consumer<ZoomProvider>(
                    builder: (context, model, child) {
                      return Transform.scale(
                        scale: model.zoom,
                        child: component ?? const SizedBox.shrink(),
                      );
                    },
                  ),
                ],
              ),
            ),
            Divider(
              height: 0,
              color: context.theme.dividerColor.withOpacity(0.5),
            ),
            const CoreBottomBar(),
          ],
        ),
      ),
    );
  }
}

class CurrentStory extends StatelessWidget {
  const CurrentStory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final story = context.watch<StoryProvider>().currentStory;

    return story?.builder(
            context, context.watch<CanvasDelegateProvider>().storyProvider!) ??
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('😉', style: context.textTheme.headline2),
              const SizedBox(height: 12),
              const Text('Select a Story!'),
            ],
          ),
        );
  }
}
