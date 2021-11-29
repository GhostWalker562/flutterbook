import 'package:analyzer/dart/element/element.dart';
import 'package:flutterbook/src/utils/type_checker.dart';

//In order to get the component states, you will pass in the path to the componenent library
//such as, ../navigation/models/organizers.dart or 'package:flutterbook/src/utils/type_checker.dart'
getPackageDetails(url) {
  final componentChecker = TypeChecker.fromUrl(url);
  final allElements = [];
  final componentClasses = allElements.fold<Set<ClassElement>>(<ClassElement>{}, (acc, element) {
    if (componentChecker.isAssignableFrom(element) && element is ClassElement) {
      acc.add(element);
    }
    return acc;
  });

  return componentClasses;
}
