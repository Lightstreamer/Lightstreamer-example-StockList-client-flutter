# Lightstreamer-example-StockList-client-flutter

This project includes a demo client showing integration between [Lightstreamer](https://lightstreamer.com/) and [Flutter App Development Toolkit](https://flutter.dev/).
In particular the demo shows how to use the [lightstreamer_flutter_client](https://pub.dev/packages/lightstreamer_flutter_client) plugin package.

![screenshot](screen_large.png)<br>

## Details

This app is a very basic example of integration between Lightstreamer and Flutter, showing the opening and closing of a client session with the server
and the subscription of a couple of Items of the demo StockList to get the real-time data.

### Import the package

To add the Lightstreamer plugin to your Flutter application:

1. Depend on it. Open the `pubspec.yaml` file located inside the app folder, and add `lightstreamer_flutter_client: ` under dependencies.

        dependencies:
            flutter:
                sdk: flutter

            # The following adds the Cupertino Icons font to your application.
            # Use with the CupertinoIcons class for iOS style icons.
            cupertino_icons: ^1.0.2
            # The following adds the Lightstreamer plugin to your application.
            lightstreamer_flutter_client: ^1.0.0

2. Install it. From the terminal: run `flutter pub get`. From Android Studio/IntelliJ: Click Packages get in the action ribbon at the top of pubspec.yaml. From VS Code: Click Get Packages located in right side of the action ribbon at the top of pubspec.yaml.

3. Import it. Add a corresponding import statement in the Dart code.

        import 'package:lightstreamer_flutter_client/lightstreamer_flutter_client.dart';


## Target Android Platform

You can build and run the demo with [Android Studio](https://developer.android.com/studio).
Just open the `android` folder from Android Studio and press `Run 'app'`.

## Target iOS Platform

To run build and rund the demo with [Xcode](https://developer.apple.com/xcode/), open the file `ios/Runner.xcworkspace` and click the menu item `Product>Run`. The first time, you may need to run the commands `flutter pub get` and `flutter build ios` from the terminal.

## See Also

### Lightstreamer Adapters Needed by This Demo Client

* [Lightstreamer - Stock- List Demo - Java Adapter](https://github.com/Lightstreamer/Lightstreamer-example-Stocklist-adapter-java)
* [Lightstreamer - Reusable Metadata Adapters- Java Adapter](https://github.com/Lightstreamer/Lightstreamer-example-ReusableMetadata-adapter-java)

### Related Projects

* [Lightstreamer - Stock-List Demos - HTML Clients](https://github.com/Lightstreamer/Lightstreamer-example-Stocklist-client-javascript)
* [Lightstreamer - Stock-List Demo - iOS Client](https://github.com/Lightstreamer/Lightstreamer-example-StockList-client-ios)
* [Lightstreamer - Stock-List Demo with APNs Push Notifications - iOS Client](https://github.com/Lightstreamer/Lightstreamer-example-MPNStockList-client-ios)
* [Lightstreamer - Stock-List Demo - Android Client](https://github.com/Lightstreamer/Lightstreamer-example-AdvStockList-client-android)
* [Lightstreamer - Stock-List Demo - React Native Client](https://github.com/Lightstreamer/Lightstreamer-example-StockList-client-reactnative)
* [Lightstreamer - Basic Stock-List Demo - OS X Client](https://github.com/Lightstreamer/Lightstreamer-example-StockList-client-osx)
* [Lightstreamer - Basic Stock-List Demo - Electron Client](https://github.com/Lightstreamer/Lightstreamer-example-StockList-client-electron)
* [Lightstreamer - Basic Stock-List Demo - HTML (React) Client](https://github.com/Lightstreamer/Lightstreamer-example-StockList-client-react)

## Lightstreamer Compatibility Notes

* Compatible with [Lightstreamer Android Client SDK](https://search.maven.org/artifact/com.lightstreamer/ls-android-client/4.2.5/jar) 4.2.0 or newer.

* Compatible with [Lightstreamer Swift Client SDK](https://github.com/Lightstreamer/Lightstreamer-lib-client-swift) 5.0.0 or newer.