

import 'package:dartdoc/dartdoc.dart';
import 'package:dartdoc/src/render/template_renderer.dart';
import 'package:async/async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterbook/src/utils/package_graph.dart';

// @dart=2.9

void main() {


final _testPackageManager =  DartDocPackageGraph('lib');
Future<PackageGraph>  testPackageUse = _testPackageManager.bootBasicPackage();



  // group("test value", () {
  //   Library? library;
  //   Class? classDef;

  //   setUpAll(() async {
  //     library = (await testPackageUse)
  //         .libraries
  //         .firstWhere((l) => l.name == 'package:flutterbook/src/navigation/models/organizer.dart');

  //     classDef = library!.classes.firstWhere((c) => c.name == 'ComponentState');
  //   });

  //   test("verify info", () {
  //       expect(classDef!.documentationComment, isNot(contains('{@tool')));
  //   });
  });
}