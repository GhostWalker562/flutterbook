import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

import '../../routing/controls.dart';

abstract class Organizer {
  final String name;
  final OrganizerType type;
  final List<Organizer> organizers;
  Organizer? parent;

  /// Abstract class for organizer panel in the left.
  Organizer(this.name, this.type, this.organizers);
}

enum OrganizerType { folder, component, category }

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
  final String stateName;
  final String? docPath;
  final Widget Function(BuildContext, ControlsInterface) builder;
  Component? parent;

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
    required this.stateName,
    required this.builder,
    this.docPath,
  });
  factory ComponentState.center(
          {required String stateName, required Widget child, String? docName}) =>
      ComponentState(
        stateName: stateName,
        docPath: docName,
        builder: (_, __) => Center(child: child),
      );
  factory ComponentState.child(
          {required String stateName, required Widget child, String? docName}) =>
      ComponentState(
        stateName: stateName,
        docPath: docName,
        builder: (_, __) => child,
      );
}
