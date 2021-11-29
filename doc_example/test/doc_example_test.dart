// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: non_constant_identifier_names
// @dart=2.9
library dartdoc.model_test;

import 'package:dartdoc/dartdoc.dart';
import 'package:test/test.dart';

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
  PackageGraph packageGraph;
  Library fakeLibrary;
  setUpAll(() async {
    // Use model_special_cases_test.dart for tests that require
    // a different package graph.
    packageGraph = await bootBasicPackage('testing/test_package');
    fakeLibrary = packageGraph.libraries.firstWhere((lib) => lib.name == 'fake');
  });

  group('Tools', () {
    Class _NonCanonicalToolUser;
    Method invokeToolNonCanonical;

    setUpAll(() {
      _NonCanonicalToolUser =
          fakeLibrary.allClasses.firstWhere((c) => c.name == '_NonCanonicalToolUser');
      invokeToolNonCanonical = _NonCanonicalToolUser.instanceMethods
          .firstWhere((m) => m.name == 'invokeToolNonCanonical');
    });

    group('does _not_ invoke a tool multiple times unnecessarily', () {
      test('non-canonical subclass case', () {
        expect(invokeToolNonCanonical.isCanonical, isFalse);
      });
    });
  });
}