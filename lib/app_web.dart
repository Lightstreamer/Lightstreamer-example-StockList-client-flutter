import 'package:flutter/material.dart';
import 'package:lightstreamer_flutter_client/lightstreamer_client_web.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    LightstreamerClient.setLoggerProvider(new ConsoleLoggerProvider(ConsoleLogLevel.WARN));
    return MaterialApp(
      title: 'Lightstreamer :: Flutter :: Stock-List Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color(0xff4c8f4c)),
          ),
        ),
      ),
      home: MyHomePage(title: 'Lightstreamer - Flutter Demo'),
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

class _MyClientListener extends ClientListener {
  final _MyHomePageState _parent;

  _MyClientListener(this._parent);

  @override
  void onStatusChange(String status) {
    _parent._consumeMessage(status);
  }
}

class _MySubscriptionListener extends SubscriptionListener {
  final _MyHomePageState _parent;

  _MySubscriptionListener(this._parent);

  @override
  void onItemUpdate(ItemUpdate updateInfo) {
    _parent._consumeRTMessage(updateInfo);
  }
}

class _MyHomePageState extends State<MyHomePage> {
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

  final LightstreamerClient _client;
  final Subscription _sub2;
  final Subscription _sub9;

  _MyHomePageState() : 
    _client = new LightstreamerClient("https://push.lightstreamer.com/", "WELCOME"),
    _sub2 = new Subscription("MERGE", ["item2"], ["last_price", "time", "stock_name"]),
    _sub9 = new Subscription("MERGE", ["item9"], ["last_price", "time", "stock_name"])
  {
    var subListener = _MySubscriptionListener(this);
    _sub2
      ..setDataAdapter("STOCKS")
      ..setRequestedMaxFrequency("7")
      ..setRequestedSnapshot("yes")
      ..addListener(subListener);
    _sub9
      ..setDataAdapter("STOCKS")
      ..setRequestedMaxFrequency("7")
      ..setRequestedSnapshot("yes")
      ..addListener(subListener);
    _client.addListener(new _MyClientListener(this));
  }

  void _consumeMessage(String status) {
    setState(() {
      _lsclientStatus = status;
      if (_lsclientStatus.startsWith("CONNECTED")) {
        statuscolor = Colors.green;
      } else if (_lsclientStatus.startsWith("DISCONNECTED")) {
        statuscolor = Colors.red;
      } else if (_lsclientStatus.startsWith("CONNECTING")) {
        statuscolor = Colors.orange;
      }
    });
  }

  void _consumeRTMessage(ItemUpdate update) {
    setState(() {
      var item = update.getItemName();
      if (item == "item2") {
        if (update.isValueChanged("last_price")){
          _last2 = update.getValue("last_price")!;
        }
        if (update.isValueChanged("time")){
          _time2 = update.getValue("time")!;
        }
        if (update.isValueChanged("stock_name")){
          _name2 = update.getValue("stock_name")!;
        }
        highlightcolor = Colors.yellow;
      } else if (item == "item9") {
        if (update.isValueChanged("last_price")){
          _last7 = update.getValue("last_price")!;
        }
        if (update.isValueChanged("time")){
          _time7 = update.getValue("time")!;
        }
        if (update.isValueChanged("stock_name")){
          _name7 = update.getValue("stock_name")!;
        }
        highlightcolor7 = Colors.yellow;
      }
    });
  }

  void _startRealTime() {
    _client.connect();
  }

  void _stopRealTime() {
    _client.disconnect();
  }

  void _subscribe(String item) {
    Subscription sub = (item == "item2" ? _sub2 : item == "item9" ? _sub9 : null)!;
    if (sub.isActive()) {
      _client.unsubscribe(sub);
    } else {
      _client.subscribe(sub);
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

    final theme = Theme.of(context);
    final style = theme.textTheme.headlineMedium!.copyWith(
      color: const Color(0xFF063d27),
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        titleSpacing: 0,
        toolbarHeight: 130,
        title: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image.asset(
              'assets/banner.jpg',
              fit: BoxFit.cover,
            ),
            Row(
              children: [
                FlutterLogo(
                  size: 100,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        fit: BoxFit.cover,
                      ),
                      Text(
                        'Flutter Demo',
                        style: style,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
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
            SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Stop Realtime from Lightstreamer'),
              onPressed: _stopRealTime,
            ),
            SizedBox(height: 10),
            Text(
              _lsclientStatus,
              style: TextStyle(backgroundColor: statuscolor),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Sub/UnSub to item2'),
              onPressed: () => _subscribe('item2'),
            ),
            SizedBox(height: 10),
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
            SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Sub/Unsub to item9'),
              onPressed: () => _subscribe('item9'),
            ),
            SizedBox(height: 10),
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
