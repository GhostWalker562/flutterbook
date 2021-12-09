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

                        Widget element =
                            model.tab == editor.FlutterBookTab.canvas
                                ? _Canvas(component)
                                : SingleChildScrollView(
                                    child: _Doc(state, currentStory),
                                  );
                        return element;
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

class _Canvas extends StatelessWidget {
  final Widget? component;
  _Canvas(this.component);
  @override
  Widget build(BuildContext context) {
    return Consumer<ZoomProvider>(
      builder: (context, model, child) {
        TransformationController _transformation = TransformationController();
        _transformation.value = Matrix4.identity()..scale(model.zoom);
        return context.watch<DevicePreviewProvider>().show
            ? _DevicePreviewCanvas(component, _transformation)
            : _InteractiveViewerCanvas(component, _transformation);
      },
    );
  }
}

class _DevicePreviewCanvas extends StatelessWidget {
  final Widget? component;
  final TransformationController controller;
  _DevicePreviewCanvas(this.component, this.controller);
  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      builder: (context) {
        return InteractiveViewer(
          boundaryMargin: EdgeInsets.all(double.infinity),
          child: component ?? const SizedBox.shrink(),
          panEnabled: true,
          transformationController: controller,
        );
      },
    );
  }
}

class _Doc extends StatelessWidget {
  final ComponentState? currentState;
  final List<ComponentState> states;

  _Doc(this.states, this.currentState);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: states
          .where((i) => i.parent == currentState?.parent)
          .map(
            (item) => DocPanel(
              markdown: item.markdown,
              component: item.builder(
                context,
                context.watch<CanvasDelegateProvider>().storyProvider!,
              ),
              stateName: item.stateName,
            ),
          )
          .toList(),
    );
  }
}

class _InteractiveViewerCanvas extends StatelessWidget {
  final Widget? component;
  final TransformationController controller;
  _InteractiveViewerCanvas(this.component, this.controller);
  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      boundaryMargin: EdgeInsets.all(double.infinity),
      child: component ?? const SizedBox.shrink(),
      panEnabled: true,
      transformationController: controller,
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
