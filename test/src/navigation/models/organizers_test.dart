import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterbook/flutterbook.dart';
import 'package:flutterbook/src/routing/controls.dart';

void main() {
  group('Component State Path', () {
    final stub = (BuildContext context, ControlsInterface controls) {
      throw Exception('Unexpected build');
    };

    final baseState = ComponentState(stateName: 'My State', builder: stub);

    test('Standalone state', () {
      expect(baseState.path, 'my-state');
    });

    test('Component parent', () {
      final top = Component(componentName: 'Parent 1', states: [baseState]);
      expect(top.states.first.path, 'parent-1/my-state');
    });

    test('Folder parent', () {
      final folder = Folder(
        folderName: 'My Folder',
        organizers: [
          Component(componentName: 'My Component', states: [baseState]),
        ],
      );

      final component = folder.organizers.first as Component;
      expect(component.states.first.path, 'my-folder/my-component/my-state');
    });

    test('Category parent', () {
      final category = Category(
        categoryName: 'My Category',
        organizers: [
          Folder(
            folderName: 'My Folder',
            organizers: [
              Component(componentName: 'My Component', states: [baseState]),
            ],
          ),
        ],
      );

      final component = category.organizers.first.organizers.first as Component;
      expect(
        component.states.first.path,
        'my-category/my-folder/my-component/my-state',
      );
    });
  });
}
