import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../styled_widgets/smooth_scroll.dart';
import '../../utils/utils.dart';
import '../navigation.dart';

class NavigationPanel extends StatefulWidget {
  const NavigationPanel({
    Key? key,
    required this.categories,
    this.onComponentSelected,
    this.headerPadding,
    this.header,
  }) : super(key: key);

  final List<Category> categories;
  final void Function(ComponentState?)? onComponentSelected;
  final Widget? header;
  final EdgeInsetsGeometry? headerPadding;

  @override
  _NavigationPanelState createState() => _NavigationPanelState();
}

class _NavigationPanelState extends State<NavigationPanel> {
  final ScrollController controller = ScrollController();
  ComponentState? selectedComponent;

  final TextEditingController search = TextEditingController();
  String query = '';

  void _onComponentSelected(ComponentState state) {
    ComponentState? current = state;
    if (current == selectedComponent) current = null;
    widget.onComponentSelected?.call(current);
    selectedComponent = current;
    setState(() {});
  }

  Widget _buildCategories(BuildContext context, int i) {
    final Category item = widget.categories[i];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 12.0, bottom: 4, left: 20, right: 20),
          child: Text(
            item.name,
            style: context.textTheme.displayMedium!.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
        ),
        ..._buildOrganizers(item, 1, query)
      ],
    );
  }

  List<Widget> _buildOrganizers(Organizer category, int layer, String query) {
    final List<Widget> organizers = <Widget>[];
    final double layerPadding = layer * 6.0;
    for (final Organizer item in category.organizers) {
      final List<Widget> current = <Widget>[];
      switch (item.type) {
        case OrganizerType.folder:
          current.add(
            FolderTile(
              organizers: _buildOrganizers(item, layer + 3, query),
              padding: layerPadding,
              item: item,
            ),
          );
          break;
        case OrganizerType.component:
          final lowerQuery = query.toLowerCase();
          if (query.isEmpty || item.name.toLowerCase().contains(lowerQuery)) {
            current.add(
              ComponentTile(
                states: (item as Component)
                    .states
                    .map(
                      (e) => ComponentStateTile(
                        isSelected: selectedComponent == e,
                        onSelected: _onComponentSelected,
                        padding: layerPadding,
                        item: e,
                      ),
                    )
                    .toList(),
                padding: layerPadding,
                item: item,
              ),
            );
          }
          break;
        default:
      }
      organizers.add(Column(children: current));
    }
    return organizers;
  }

  void _searchOrganizers(String query) {
    this.query = query;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 50, maxWidth: 250),
      child: Column(
        children: [
          widget.header ?? const _NavigationHeader(),
          SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Overlay(
                initialEntries: [
                  OverlayEntry(
                    builder: (context) => CupertinoSearchTextField(
                      itemSize: 16,
                      controller: search,
                      onChanged: _searchOrganizers,
                      onSuffixTap: () {
                        search.text = '';
                        _searchOrganizers('');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                if (kIsWeb) {
                  // If web, we just disable smooth scrolling.
                  return ListView.separated(
                    controller: controller,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: widget.categories.length,
                    itemBuilder: _buildCategories,
                    padding: const EdgeInsets.only(bottom: 8),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                  );
                } else {
                  // If windows or macos we can allow smooth scrolling.
                  if (Platform.isMacOS || Platform.isWindows) {
                    return SmoothScroll(
                      controller: controller,
                      curve: Curves.easeOutExpo,
                      scrollSpeed: 50,
                      child: ListView.separated(
                        controller: controller,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.categories.length,
                        itemBuilder: _buildCategories,
                        padding: const EdgeInsets.only(bottom: 8),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                      ),
                    );
                  } else {
                    // If it's mobile then we're not using smooth scrolling.
                    return ListView.separated(
                      controller: controller,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: widget.categories.length,
                      itemBuilder: _buildCategories,
                      padding: const EdgeInsets.only(bottom: 8),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationHeader extends StatelessWidget {
  const _NavigationHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(FeatherIcons.bookOpen, color: Color(0xFFD689EF)),
                const SizedBox(width: 8),
                Text(
                  'Flutterbook',
                  style: context.textTheme.headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Text(
            'by MOONSDONTBURN',
            style: context.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
