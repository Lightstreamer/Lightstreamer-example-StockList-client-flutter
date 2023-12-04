# Lightstreamer-example-StockList-client-flutter

This project includes a demo client showing integration between [Lightstreamer](https://lightstreamer.com/) and [Flutter App Development Toolkit](https://flutter.dev/).
In particular the demo shows how to use the [Lightstreamer Flutter Client SDK](https://pub.dev/packages/lightstreamer_flutter_client).

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

            # The following adds the Lightstreamer plugin to your application.
            lightstreamer_flutter_client: ^1.2.0

2. Install it. From the terminal: run `flutter pub get`.\
From Android Studio/IntelliJ: Click `Packages get` in the action ribbon at the top of `pubspec.yaml`.\
From VS Code: Click `Get Packages` located in right side of the action ribbon at the top of `pubspec.yaml`.

3. (iOS/Android) Add a corresponding import statement in the Dart code.

    `import 'package:lightstreamer_flutter_client/lightstreamer_flutter_client.dart';`

4. (Web) 
    - Get the [Lightstreamer Client Web SDK](https://www.npmjs.com/package/lightstreamer-client-web)

    - Copy the file `lightstreamer-core.min.js` (or the file `lightstreamer-mpn.min.js` if you need the Web Push Notifications) in the `web` folder of your Flutter app

    - Put the following line in the `<head>` section of the file `index.html` just before every other `<script>` element:

        ```html
        <script src="lightstreamer-core.min.js" data-lightstreamer-ns="lightstreamer"></script>
        ```

        or the following line if you need the Web Push Notifications via Firebase or Apple APNs

        ```html
        <script src="lightstreamer-mpn.min.js" data-lightstreamer-ns="lightstreamer"></script>
        ```

    - Add the following import to your app:

        ```dart
        import 'package:lightstreamer_flutter_client/lightstreamer_client_web.dart';
        ```

## Target Android Platform

You can build and run the demo with [Android Studio](https://developer.android.com/studio).
Just open the `android` folder from Android Studio and press `Run 'app'`.

## Target iOS Platform

To build and run the demo with [Xcode](https://developer.apple.com/xcode/), open the file `ios/Runner.xcworkspace` and click the menu item `Product>Run`. The first time, you may need to run the commands `flutter pub get` and `flutter build ios` from the terminal.

## Target Web Platform

To run the demo on a browser, execute this command: `flutter run -d chrome`.

## See Also

### Lightstreamer Adapters Needed by This Demo Client

* [Lightstreamer - Stock- List Demo - Java Adapter](https://github.com/Lightstreamer/Lightstreamer-example-Stocklist-adapter-java)
* [Lightstreamer - Reusable Metadata Adapters- Java Adapter](https://github.com/Lightstreamer/Lightstreamer-example-ReusableMetadata-adapter-java)

### Related Projects

* [Lightstreamer Flutter Client SDK](https://pub.dev/packages/lightstreamer_flutter_client)
* [Lightstreamer - Stock-List Demos - HTML Clients](https://github.com/Lightstreamer/Lightstreamer-example-Stocklist-client-javascript)
* [Lightstreamer - Stock-List Demo - iOS Client](https://github.com/Lightstreamer/Lightstreamer-example-StockList-client-ios)
* [Lightstreamer - Stock-List Demo with APNs Push Notifications - iOS Client](https://github.com/Lightstreamer/Lightstreamer-example-MPNStockList-client-ios)
* [Lightstreamer - Stock-List Demo - Android Client](https://github.com/Lightstreamer/Lightstreamer-example-AdvStockList-client-android)

## Lightstreamer Compatibility Notes

* Compatible with Lightstreamer Flutter Client SDK 1.2.0 or higher.

* For a version of this example compatible with Lightstreamer SDK for Flutter Clients version 1.1.x or earlier, please refer to [this tag](https://github.com/Lightstreamer/Lightstreamer-example-StockList-client-flutter/releases/tag/for_client_1.1.x).

* Compatible with Lightstreamer Server 7.4.0 or higher.
