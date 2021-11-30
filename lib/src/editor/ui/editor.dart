import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutterbook/src/editor/providers/device_preview_provider.dart';
import 'package:flutterbook/src/editor/providers/tab_provider.dart';
import 'package:flutterbook/src/editor/ui/doc_component.dart';
import 'package:flutterbook/src/routing/router.dart';
import 'package:provider/provider.dart';

import '../../../flutterbook.dart';
import '../../routing/story_provider.dart';
import '../../utils/utils.dart';
import '../providers/canvas_delegate.dart';
import '../providers/grid_provider.dart';
import '../providers/zoom_provider.dart';
import 'editor_bottom_bar.dart';
import 'editor_tabs.dart' as editor;

class Editor extends StatelessWidget {
  const Editor({Key? key, required this.component}) : super(key: key);

  final Widget? component;

  @override
  Widget build(BuildContext context) {
    ComponentState? currentStory =
        context.watch<CanvasDelegateProvider>().storyProvider?.currentStory;
    StoryProvider? storyProvider =
        context.watch<CanvasDelegateProvider>().storyProvider;

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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: editor.CoreContentTabs(),
            ),
            Divider(
              height: 0,
              color: context.theme.dividerColor.withOpacity(0.5),
            ),
            // Canvas
            Expanded(
              child: ClipRect(
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
                    Consumer<TabProvider>(
                      builder: (context, model, child) {
                        List<ComponentState> state = recursiveRetrievalOfStates(
                            context.read<List<Category>>());

                        return model.tab == editor.FlutterBookTab.canvas
                            ? Consumer<ZoomProvider>(
                                builder: (context, model, child) {
                                  TransformationController _transformation =
                                      TransformationController();
                                  _transformation.value = Matrix4.identity()
                                    ..scale(model.zoom);
                                  return context
                                          .watch<DevicePreviewProvider>()
                                          .show
                                      ? DevicePreview(
                                          builder: (context) {
                                            return InteractiveViewer(
                                              panEnabled: true,
                                              boundaryMargin: EdgeInsets.all(
                                                  double.infinity),
                                              child: component ??
                                                  const SizedBox.shrink(),
                                              transformationController:
                                                  _transformation,
                                            );
                                          },
                                        )
                                      : InteractiveViewer(
                                          panEnabled: true,
                                          boundaryMargin:
                                              EdgeInsets.all(double.infinity),
                                          transformationController:
                                              _transformation,
                                          child: component ??
                                              const SizedBox.shrink(),
                                        );
                                },
                              )
                            : SingleChildScrollView(
                                child: Center(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        ...state
                                            .where((i) =>
                                                i.parent ==
                                                currentStory?.parent)
                                            .map(
                                              (item) => DocPanel(
                                                stateName: item.stateName,
                                                docs: item.docs,
                                                component: item.builder(
                                                  context,
                                                  context
                                                      .watch<
                                                          CanvasDelegateProvider>()
                                                      .storyProvider!,
                                                ),
                                              ),
                                            )
                                            .toList()
                                      ],
                                    ),
                                  ),
                                ),
                              );
                      },
                    )
                  ],
                ),
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

class Story extends StatelessWidget {
  const Story({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final story = context.watch<StoryProvider>().currentStory;

    return story?.builder(
            context, context.watch<CanvasDelegateProvider>().storyProvider!) ??
        Container(
          color: context.colorScheme.onSecondary,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('😉', style: context.textTheme.headline2),
                const SizedBox(height: 12),
                const Text('Select a Story!'),
              ],
            ),
          ),
        );
  }
}
