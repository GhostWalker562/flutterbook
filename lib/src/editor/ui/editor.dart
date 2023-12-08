import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutterbook/src/editor/providers/device_preview_provider.dart';
import 'package:flutterbook/src/editor/providers/pan_provider.dart';
import 'package:flutterbook/src/editor/providers/tab_provider.dart';
import 'package:flutterbook/src/editor/ui/doc_component/doc_component.dart';
import 'package:flutterbook/src/editor/ui/doc_markdown.dart';
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
                                : _Doc(state, currentStory);
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
            ? _DevicePreviewCanvas(component)
            : _InteractiveViewerCanvas(component, _transformation);
      },
    );
  }
}

class _DevicePreviewCanvas extends StatelessWidget {
  final Widget? component;
  _DevicePreviewCanvas(
    this.component,
  );
  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      builder: (context) {
        return component ?? Container();
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
    final TextStyle titleStyle =
        Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).hintColor,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            );

    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 64),
          constraints: BoxConstraints(maxWidth: 900),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentState?.parent?.componentName ?? '',
                style: titleStyle,
              ),
              if (currentState?.parent?.componentMarkdown != null)
                DocMarkDown(
                  markdown: currentState?.parent?.componentMarkdown ?? '',
                ),
              ...states
                  .where((i) => i.parent == currentState?.parent)
                  .map(
                    (item) => DocPanel(
                      component: item.builder(
                        context,
                        context.watch<CanvasDelegateProvider>().storyProvider!,
                      ),
                      codeSample: item.codeSample,
                      markdown: item.markdown,
                      stateName: item.stateName,
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _InteractiveViewerCanvas extends StatefulWidget {
  final Widget? component;
  final TransformationController controller;
  _InteractiveViewerCanvas(this.component, this.controller);

  @override
  State<_InteractiveViewerCanvas> createState() =>
      _InteractiveViewerCanvasState();
}

class _InteractiveViewerCanvasState extends State<_InteractiveViewerCanvas>
    with TickerProviderStateMixin {
  Animation<Matrix4>? _animationReset;
  late AnimationController _controllerReset;

  @override
  void initState() {
    super.initState();
    _controllerReset = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  void _onAnimateReset() {
    widget.controller.value = _animationReset!.value;
    if (!_controllerReset.isAnimating) {
      _animationReset?.removeListener(_onAnimateReset);
      _animationReset = null;
      _controllerReset.reset();
    }
  }

  void _animateResetInitialize() {
    _controllerReset.reset();
    _animationReset = Matrix4Tween(
      begin: widget.controller.value,
      end: Matrix4.identity(),
    ).animate(_controllerReset);
    _animationReset?.addListener(_onAnimateReset);
    _controllerReset.forward();
  }

// Stop a running reset to home transform animation.
  void _animateResetStop() {
    _controllerReset.stop();
    _animationReset?.removeListener(_onAnimateReset);
    _animationReset = null;
    _controllerReset.reset();
  }

  void _onInteractionStart(ScaleStartDetails details) {
    // If the user tries to cause a transformation while the reset animation is
    // running, cancel the reset animation.
    if (_controllerReset.status == AnimationStatus.forward) {
      _animateResetStop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PanProvider>(
      builder: (context, model, child) {
        model.addListener(() {
          if (!model.panEnabled) {
            _animateResetInitialize();
          }
        });

        return InteractiveViewer(
          boundaryMargin: EdgeInsets.all(double.infinity),
          child: widget.component ?? const SizedBox.shrink(),
          panEnabled: model.panEnabled,
          onInteractionStart: _onInteractionStart,
          transformationController: widget.controller,
        );
      },
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
                Text('😉', style: context.textTheme.displayMedium),
                const SizedBox(height: 12),
                const Text('Select a Story!'),
              ],
            ),
          ),
        );
  }
}
