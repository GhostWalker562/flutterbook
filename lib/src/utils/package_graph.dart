// This package graph utility have been stripped out of dartdocs https://github.com/dart-lang/dartdoc/blob/fb621e14f33fe5814b69b9fb7c578410682ff5c8/test/src/utils.dart
// This enables us to scan all the files in the lib files in order to traverse the element tree and find all components in the file

import 'package:dartdoc/dartdoc.dart';

class DartDocPackageGraph {
  final String dirPath;

  DartDocPackageGraph(this.dirPath);

  /// Convenience factory to build a [DartdocOptionContext] and associate it with a
  /// [DartdocOptionSet] based on the current working directory.
  Future<DartdocOptionContext> contextFromArgv(
      List<String> argv, PackageMetaProvider packageMetaProvider) async {
    var optionSet = await DartdocOptionSet.fromOptionGenerators(
        'dartdoc', [createDartdocOptions], packageMetaProvider);
    optionSet.parseArguments(argv);
    return DartdocOptionContext.fromDefaultContextLocation(
        optionSet, pubPackageMetaProvider.resourceProvider);
  }

  Future<PackageGraph> bootBasicPackage() async {
    var resourceProvider = pubPackageMetaProvider.resourceProvider;
    final excludeLibraries = ['css', 'code_in_comments'];
    final additionalArguments = ['--no-link-to-remote'];
    var dir = resourceProvider.getFolder(resourceProvider.pathContext
        .absolute(resourceProvider.pathContext.normalize(dirPath)));

    final optionSet = await DartdocOptionSet.fromOptionGenerators(
      'dartdoc',
      [createDartdocOptions],
      pubPackageMetaProvider,
    );
    optionSet.parseArguments([
      '--input',
      dir.path,
      '--sdk-dir',
      pubPackageMetaProvider.defaultSdkDir.path,
      '--exclude',
      excludeLibraries.join(','),
      '--allow-tools',
      ...additionalArguments,
    ]);
    final context = DartdocOptionContext.fromDefaultContextLocation(
        optionSet, pubPackageMetaProvider.resourceProvider);
    return await PubPackageBuilder(
            context, pubPackageMetaProvider, PhysicalPackageConfigProvider())
        .buildPackageGraph();
  }
}
