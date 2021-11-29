// @dart=2.9

import 'package:dartdoc/dartdoc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterbook/flutterbook.dart';
import 'package:flutterbook/src/navigation/models/organizers.dart' as fb;
import 'package:flutterbook/src/routing/controls.dart';

Future<PackageGraph> bootBasicPackage(String dirPath) async {
  final excludeLibraries = ['css', 'code_in_comments'];
  final additionalArguments = ['--no-link-to-remote'];
  final resourceProvider = pubPackageMetaProvider.resourceProvider;
  final dir = resourceProvider.getFolder(
      resourceProvider.pathContext.absolute(resourceProvider.pathContext.normalize(dirPath)));
  final optionSet = await DartdocOptionSet.fromOptionGenerators(
    'dartdoc',
    [createDartdocOptions],
    pubPackageMetaProvider,
  );
  optionSet.parseArguments([
    '--input',
    dir.path,
    '--exclude',
    excludeLibraries.join(','),
    '--allow-tools',
    ...additionalArguments,
  ]);
  final context = DartdocOptionContext.fromDefaultContextLocation(
      optionSet, pubPackageMetaProvider.resourceProvider);
  return await PubPackageBuilder(context, pubPackageMetaProvider, PhysicalPackageConfigProvider())
      .buildPackageGraph();
}

Future<DartdocOptionContext> contextFromArgv(
    List<String> argv, PackageMetaProvider packageMetaProvider) async {
  var optionSet = await DartdocOptionSet.fromOptionGenerators(
      'dartdoc', [createDartdocOptions], packageMetaProvider);
  optionSet.parseArguments(argv);
  return DartdocOptionContext.fromDefaultContextLocation(
      optionSet, pubPackageMetaProvider.resourceProvider);
}


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
      final category = fb.Category(
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

  group('Documentation', () {
    PackageGraph packageGraph;
    Library libraryFile;
    setUpAll(() async {
       packageGraph = await bootBasicPackage('lib');
    });


    test("test group", () {
      expect(libraryFile.element.displayName, "Object");
    });
  });
}
