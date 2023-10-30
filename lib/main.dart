import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lightstreamer_flutter_client/lightstreamer_flutter_client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Lightstreamer-Flutter Demo Home Page 2'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Get the number of Lightstreamer sessions currently active on your server.
  String _lsclientStatus = " -- ";

  Color statuscolor = Colors.white;

  Color highlightcolor = Colors.blueGrey;
  Color highlightcolor7 = Colors.blueGrey;

  String _name2 = " ---- ";
  String _time2 = " ---- ";
  String _last2 = " ---- ";
  String _name7 = " ---- ";
  String _time7 = " ---- ";
  String _last7 = " ---- ";

  String static_sub_id_2 = "";
  String static_sub_id_7 = "";

  /*
  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('connect');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  } */

  Future<String> _consumeMessage(String? message) async {
    String currentMessage = message as String;

    if (currentMessage.startsWith("StatusChange:")) {
      String currentStatus = currentMessage.split(":")[1];

      developer.log("Received message: " + currentStatus);

      setState(() {
        _lsclientStatus = currentStatus;
        if (_lsclientStatus.startsWith("CONNECTED")) {
          statuscolor = Colors.green;
        } else if (_lsclientStatus.startsWith("DISCONNECTED")) {
          statuscolor = Colors.red;
        } else if (_lsclientStatus.startsWith("CONNECTING")) {
          statuscolor = Colors.orange;
        }
      });
    }
    return "ok";
  }

  Future<String> _consumeRTMessage(
      String item, String fieldName, String fieldValue) async {
    developer.log("Received update for item: " + item);

    setState(() {
      if (item.startsWith("item2")) {
        if (fieldName.startsWith("last_price")) {
          _last2 = fieldValue;
        } else if (fieldName.startsWith("time")) {
          _time2 = fieldValue;
        } else if (fieldName.startsWith("stock_name")) {
          _name2 = fieldValue;
        }

        highlightcolor = Colors.yellow;
      } else if (item.startsWith("item9")) {
        if (fieldName.startsWith("last_price")) {
          _last7 = fieldValue;
        } else if (fieldName.startsWith("time")) {
          _time7 = fieldValue;
        } else if (fieldName.startsWith("stock_name")) {
          _name7 = fieldValue;
        }

        highlightcolor7 = Colors.yellow;
      }
    });

    return "ok";
  }

  Future<void> _startRealTime() async {
    String currentStatus;

    developer.log("_startRealTime clicked.");

    try {
      LightstreamerFlutterClient.enableLog();
      
      Map<String, String> params = {"user": "prova1", "password": "qwerty!"};

      currentStatus = await LightstreamerFlutterClient.connect(
              "https://push.lightstreamer.com/", "WELCOME", params) ??
          'Unknown client session status';
    } on PlatformException catch (e) {
      currentStatus =
          "Problems in starting a session with Lightstreamer: '${e.message}' .";
    }

    setState(() {
      _lsclientStatus = currentStatus;
    });

    LightstreamerFlutterClient.setClientListener(_consumeMessage);
  }

  Future<void> _stopRealTime() async {
    String currentStatus;

    try {
      currentStatus = await LightstreamerFlutterClient.disconnect() ??
          'Unknown client session status';
    } on PlatformException catch (e) {
      currentStatus =
          "Problems in starting a session with Lightstreamer: '${e.message}' .";
    }

    setState(() {
      _lsclientStatus = currentStatus;
    });
  }

  Future<void> _subscribe(String items) async {
    // Start receiving data from Lightstreamer

    String? subId = "";

    developer.log("_subscribe clicked.");

    if (items.startsWith("item2")) {
      if (static_sub_id_2 == "") {
        try {
          Map<String, String> params = {
            "dataAdapter": "STOCKS",
            "requestedMaxFrequency": "7",
            "requestedSnapshot": "yes"
          };
          subId = await LightstreamerFlutterClient.subscribe(
              "MERGE",
              itemList: items.split(","),
              fieldList: "last_price,time,stock_name".split(","),
              parameters: params);

          static_sub_id_2 = subId as String;

          LightstreamerFlutterClient.setSubscriptionListener(
              subId, _consumeRTMessage);
        } on PlatformException {
          // ...
        }
      } else {
        try {
          subId = await LightstreamerFlutterClient.unsubscribe(static_sub_id_2);

          static_sub_id_2 = "";
        } on PlatformException {
          // ...
        }
      }
    } else {
      if (static_sub_id_7 == "") {
        try {
          Map<String, String> params = {
            "dataAdapter": "STOCKS",
            "requestedMaxFrequency": "7",
            "requestedSnapshot": "yes"
          };
          subId = await LightstreamerFlutterClient.subscribe(
              "MERGE",
              itemList: items.split(","),
              fieldList: "last_price,time,stock_name".split(","),
              parameters: params);

          static_sub_id_7 = subId as String;

          LightstreamerFlutterClient.setSubscriptionListener(
              subId, _consumeRTMessage);
        } on PlatformException {
          // ...
        }
      } else {
        try {
          subId = await LightstreamerFlutterClient.unsubscribe(static_sub_id_7);

          static_sub_id_7 = "";
        } on PlatformException {
          // ...
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    var currentStatus = _lsclientStatus;

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Start Realtime from Lightstreamer'),
              onPressed: _startRealTime,
            ),
            ElevatedButton(
              child: const Text('Stop Realtime from Lightstreamer'),
              onPressed: _stopRealTime,
            ),
            Text(
              currentStatus,
              style: TextStyle(backgroundColor: statuscolor),
            ),
            ElevatedButton(
              child: const Text('Sub/UnSub to item2'),
              onPressed: () => _subscribe('item2'),
            ),
            Text(
              _name2,
              style: TextStyle(backgroundColor: highlightcolor),
            ),
            Text(
              _time2,
              style: TextStyle(backgroundColor: highlightcolor),
            ),
            Text(
              _last2,
              style: TextStyle(backgroundColor: highlightcolor),
            ),
            ElevatedButton(
              child: const Text('Sub/Unsub to item9'),
              onPressed: () => _subscribe('item9'),
            ),
            Text(
              _name7,
              style: TextStyle(backgroundColor: highlightcolor7),
            ),
            Text(
              _time7,
              style: TextStyle(backgroundColor: highlightcolor7),
            ),
            Text(
              _last7,
              style: TextStyle(backgroundColor: highlightcolor7),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
