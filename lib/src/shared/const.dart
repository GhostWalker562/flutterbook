const DEFAULT_MARKDOWN= """
## Could Not Find Doc For Documents

If you are seeing this message, that means you have not generated docs for this component

### Create Docs For Component
 - add the latest version of dartdoc to your pubspec.yaml
 The --input is the path to your root directory in your project
 The --output is the path in your project where the assets need to stay
 - run dartdoc --format md --input "my_fake_project" --output "my_fake_project/assets/lib/docs"
 - create a component and add it to your component state with a attribute ***markdown***
""";