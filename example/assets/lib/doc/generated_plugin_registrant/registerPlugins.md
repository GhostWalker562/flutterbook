


# registerPlugins function






    *[<Null safety>](https://dart.dev/null-safety)*




void registerPlugins
([Registrar](https://api.flutter.dev/flutter/flutter_web_plugins/Registrar-class.html) registrar)






## Implementation

```dart
void registerPlugins(Registrar registrar) {
  SharedPreferencesPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
```







