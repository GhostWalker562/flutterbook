import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

import '../../routing/controls.dart';

abstract class Organizer {
  final List<Organizer> organizers;
  final OrganizerType type;
  final String name;
  Organizer? parent;

  /// Abstract class for organizer panel in the left.
  Organizer(this.name, this.type, this.organizers);
}

enum OrganizerType { category, component, folder }

class Category extends Organizer {
  final String categoryName;

  Category({required this.categoryName, required List<Organizer> organizers})
      : super(categoryName, OrganizerType.category, organizers) {
    for (final Organizer organizer in organizers) {
      organizer.parent = this;
    }
  }
}

class Folder extends Organizer {
  final String folderName;

  Folder({required this.folderName, required List<Organizer> organizers})
      : super(folderName, OrganizerType.folder, organizers) {
    for (final Organizer organizer in organizers) {
      organizer.parent = this;
    }
  }
}

class Component extends Organizer {
  final String componentName;
  final List<ComponentState> states;

  Component({
    required this.componentName,
    required this.states,
  }) : super(componentName, OrganizerType.component, const <Organizer>[]) {
    for (final ComponentState state in states) {
      state.parent = this;
    }
  }
}

class ComponentState {
  Component? parent;
  final String? markdown;
  final String stateName;
  final Widget Function(BuildContext, ControlsInterface) builder;

  String get path {
    String path = ReCase(stateName).paramCase;
    Organizer? currentParent = parent;
    while (currentParent != null) {
      path = '${ReCase(currentParent.name).paramCase}${'/$path'}';
      currentParent = currentParent.parent;
    }
    return path;
  }

  ComponentState({
    required this.builder,
    required this.stateName,
    this.markdown,
  });
  factory ComponentState.center({
    required Widget child,
    String? markdown,
    required String stateName,
  }) =>
      ComponentState(
        builder: (_, __) => Center(child: child),
        markdown: markdown,
        stateName: stateName,
      );
  factory ComponentState.child({
    required Widget child,
    String? markdown,
    required String stateName,
  }) =>
      ComponentState(
        builder: (_, __) => child,
        markdown: markdown,
        stateName: stateName,
      );
}
