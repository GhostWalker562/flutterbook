//Imported from https://github.com/dart-lang/source_gen/blob/master/source_gen/lib/src/type_checker.dart#L243-L273
// Since the classes uses mirrors and we needed to verify that the elements we are creating docs for are component states,
// we ripped the code out and used the package as needed
import 'dart:io';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

/// An abstraction around doing static type checking at compile/build time.

abstract class TypeChecker {
  const TypeChecker._();

  /// Create a new [TypeChecker] backed by a library [url].
  ///
  /// Example of referring to a `LinkedHashMap` from `dart:collection`:
  /// ```dart
  /// const linkedHashMap = const TypeChecker.fromUrl(
  ///   'dart:collection#LinkedHashMap',
  /// );
  /// ```
  ///
  /// **NOTE**: This is considered a more _brittle_ way of determining the type
  /// because it relies on knowing the _absolute_ path (i.e. after resolved
  /// `export` directives). You should ideally only use `fromUrl` when you know
  /// the full path (likely you own/control the package) or it is in a stable
  /// package like in the `dart:` SDK.
  const factory TypeChecker.fromUrl(dynamic url) = _UriTypeChecker;

  /// Returns `true` if [staticType] can be assigned to this type.
  bool isAssignableFromType(DartType staticType) =>
      isAssignableFrom(staticType.element!);

  bool isAssignableFrom(Element element) =>
      isExactly(element) ||
      (element is ClassElement && element.allSupertypes.any(isExactlyType));

  // Returns `true` if representing the exact same class as [element].
  bool isExactly(Element element);

  bool isExactlyType(DartType staticType) => isExactly(staticType.element!);
}

class _UriTypeChecker extends TypeChecker {
  final String _url;

  // Precomputed cache of String --> Uri.
  static final _cache = Expando<Uri>();

  const _UriTypeChecker(dynamic url)
      : _url = '$url',
        super._();

  @override
  bool operator ==(Object o) => o is _UriTypeChecker && o._url == _url;

  @override
  int get hashCode => _url.hashCode;

  /// Url as a [Uri] object, lazily constructed.
  Uri get uri => _cache[this] ??= normalizeUrl(Uri.parse(_url));

  /// Returns whether this type represents the same as [url].
  bool hasSameUrl(dynamic url) =>
      uri.toString() ==
      (url is String ? url : normalizeUrl(url as Uri).toString());

  @override
  bool isExactly(Element element) => hasSameUrl(urlOfElement(element));

  @override
  String toString() => '$uri';

  String urlOfElement(Element element) => element.kind == ElementKind.DYNAMIC
      ? 'dart:core#dynamic'
      // using librarySource.uri – in case the element is in a part
      : normalizeUrl(element.librarySource!.uri)
          .replace(fragment: element.name)
          .toString();

  Uri normalizeUrl(Uri url) {
    switch (url.scheme) {
      case 'dart':
        return normalizeDartUrl(url);
      case 'package':
        return packageToAssetUrl(url);
      case 'file':
        return fileToAssetUrl(url);
      default:
        return url;
    }
  }

  /// Make `dart:`-type URLs look like a user-knowable path.
  ///
  /// Some internal dart: URLs are something like `dart:core/map.dart`.
  ///
  /// This isn't a user-knowable path, so we strip out extra path segments
  /// and only expose `dart:core`.
  Uri normalizeDartUrl(Uri url) => url.pathSegments.isNotEmpty
      ? url.replace(pathSegments: url.pathSegments.take(1))
      : url;

  Uri fileToAssetUrl(Uri url) {
    if (!p.isWithin(p.current, url.path)) return url;
    return Uri(
        scheme: 'asset', path: p.join(rootPackageName, p.relative(url.path)));
  }

  /// Returns a `package:` URL converted to a `asset:` URL.
  ///
  /// This makes internal comparison logic much easier, but still allows users
  /// to define assets in terms of `package:`, which is something that makes more
  /// sense to most.
  ///
  /// For example, this transforms `package:source_gen/source_gen.dart` into:
  /// `asset:source_gen/lib/source_gen.dart`.
  Uri packageToAssetUrl(Uri url) => url.scheme == 'package'
      ? url.replace(
          scheme: 'asset',
          pathSegments: <String>[
            url.pathSegments.first,
            'lib',
            ...url.pathSegments.skip(1),
          ],
        )
      : url;
}

final String rootPackageName = () {
  final name =
      (loadYaml(File('pubspec.yaml').readAsStringSync()) as Map)['name'];
  if (name is! String) {
    throw StateError(
        'Your pubspec.yaml file is missing a `name` field or it isn\'t '
        'a String.');
  }
  return name;
}();
