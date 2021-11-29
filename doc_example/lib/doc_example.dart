/// Support for doing something awesome.
///
/// More dartdocs go here.
// @dart=2.9
library doc_example;
import 'dart:developer';
import 'dart:math';

import 'package:dartdoc/dartdoc.dart';

//export 'src/doc_example_base.dart';


// TODO: Export any libraries intended for clients of this package.

Future<PackageGraph> bootBasicPackage(String dirPath) async {
  print("TESTTTTT");
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
    print("YOOOOO");
    print(optionSet.toString());
    print(optionSet);
    inspect(optionSet);
  final context = DartdocOptionContext.fromDefaultContextLocation(
      optionSet, pubPackageMetaProvider.resourceProvider);
      print(context);
      inspect(context);
      print(pubPackageMetaProvider);
      inspect(pubPackageMetaProvider);
      print(dir);
      print(PhysicalPackageConfigProvider().toString());
      inspect( PhysicalPackageConfigProvider());

var test = PubPackageBuilder(context, pubPackageMetaProvider, PhysicalPackageConfigProvider()).buildPackageGraph();
  return await PubPackageBuilder(context, pubPackageMetaProvider, PhysicalPackageConfigProvider()).buildPackageGraph();
    //  .buildPackageGraph();
}