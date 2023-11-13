import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'client_stub.dart'
  if (dart.library.js) 'client_web.dart'
  if (dart.library.io) 'client_mobile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LsClient(),
      child: MaterialApp(
        title: 'Lightstreamer :: Flutter :: Stock-List Demo',
        theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Color(0xff4c8f4c)),
            ),
          ),
        ),
        home: MyHomePage(),
      )
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var client = context.watch<LsClient>();

    final theme = Theme.of(context);
    final style = theme.textTheme.headlineMedium!.copyWith(
      color: const Color(0xFF063d27),
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/banner.jpg',
                  fit: BoxFit.cover,
                  height: 130,
                  width: double.infinity,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => launchUrl(Uri.parse('https://flutter.dev')),
                      child: FlutterLogo(
                        size: 100,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => launchUrl(
                                Uri.parse('https://www.lightstreamer.com')),
                            child: Image.asset(
                              'assets/logo.png',
                              fit: BoxFit.cover,
                            ),
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
          SizedBox(height: 100),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  child: const Text('Connect/Disconnect'),
                  onPressed: client.connect,
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 220,
                  height: 70,
                  child: Card(
                    child: client.clientStatus == "DISCONNECTED"
                    ? ListTile(
                      leading: Icon(Icons.cloud_off),
                      title: Text(client.clientStatus),
                      textColor: client.statusColor,
                    )
                    : ListTile(
                      leading: Icon(Icons.cloud_outlined),
                      title: Text(client.clientStatus.replaceFirst(':', '\n')),
                      textColor: client.statusColor,
                    ),
                  )
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: const Text('Subscribe/Unsubscribe item2'),
                  onPressed: () => client.subscribe('item2'),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 220,
                  height: 70,
                  child: Card(
                    child: client.sub2IsSubscribed
                    ? ListTile(
                      leading: Text('\$${client.last2}'),
                      title: Text(client.name2),
                      subtitle: Text('at ${client.time2}'),
                    )
                    : client.sub2IsActive
                    ? ListTile(
                      leading: Icon(Icons.notifications_active),
                      title: Text(
                        'Subscribed',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      )
                    )
                    : ListTile(
                      leading: Icon(Icons.notifications_off),
                      title: Text(
                        'Not Subscribed',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      )
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  child: const Text('Subscribe/Unsubscribe item9'),
                  onPressed: () => client.subscribe('item9'),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 220,
                  height: 70,
                  child: Card(
                    child: client.sub9IsSubscribed
                    ? ListTile(
                      leading: Text('\$${client.last9}'),
                      title: Text(client.name9),
                      subtitle: Text('at ${client.time9}'),
                    )
                    : client.sub9IsActive
                    ? ListTile(
                      leading: Icon(Icons.notifications_active),
                      title: Text(
                        'Subscribed',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      )
                    )
                    : ListTile(
                      leading: Icon(Icons.notifications_off),
                      title: Text(
                        'Not Subscribed',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
