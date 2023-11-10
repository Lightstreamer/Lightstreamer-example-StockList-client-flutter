import 'package:flutter/material.dart';
import 'package:lightstreamer_flutter_client/lightstreamer_client_web.dart';
import 'package:lightstreamer_flutter_demo/client_api.dart';

class LsClient extends ILsClient {
  final LightstreamerClient _client;
  final Subscription _sub2;
  final Subscription _sub9;

  bool get sub2IsActive => _sub2.isActive();
  bool get sub2IsSubscribed => _sub2.isSubscribed();
  bool get sub9IsActive => _sub9.isActive();
  bool get sub9IsSubscribed => _sub9.isSubscribed();

  LsClient() : 
    _client = new LightstreamerClient("https://push.lightstreamer.com/", "WELCOME"),
    _sub2 = new Subscription("MERGE", ["item2"], ["last_price", "time", "stock_name"]),
    _sub9 = new Subscription("MERGE", ["item9"], ["last_price", "time", "stock_name"])
  {
    LightstreamerClient.setLoggerProvider(new ConsoleLoggerProvider(ConsoleLogLevel.WARN));

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

   void connect() {
    if (_client.getStatus() == "DISCONNECTED") {
      _client.connect();
    } else {
      _client.disconnect();
    }

    notifyListeners();
  }

  void subscribe(String item) {
    Subscription sub = (item == "item2" ? _sub2 : item == "item9" ? _sub9 : null)!;
    if (sub.isActive()) {
      _client.unsubscribe(sub);
    } else {
      _client.subscribe(sub);
    }

    notifyListeners();
  }
  
  void _consumeMessage(String status) {
    clientStatus = status;
    if (clientStatus.startsWith("CONNECTED")) {
      statusColor = Colors.green;
    } else if (clientStatus.startsWith("DISCONNECTED")) {
      statusColor = Colors.red;
    } else if (clientStatus.startsWith("CONNECTING")) {
      statusColor = Colors.orange;
    }

    notifyListeners();
  }
  
  void _consumeRTMessage(ItemUpdate update) {
    var item = update.getItemName();
    if (item == "item2") {
      if (update.isValueChanged("last_price")) {
        last2 = update.getValue("last_price")!;
      }
      if (update.isValueChanged("time")) {
        time2 = update.getValue("time")!;
      }
      if (update.isValueChanged("stock_name")) {
        name2 = update.getValue("stock_name")!;
      }
      highlightColor2 = Colors.yellow;
    } else if (item == "item9") {
      if (update.isValueChanged("last_price")) {
        last9 = update.getValue("last_price")!;
      }
      if (update.isValueChanged("time")) {
        time9 = update.getValue("time")!;
      }
      if (update.isValueChanged("stock_name")) {
        name9 = update.getValue("stock_name")!;
      }
      highlightColor9 = Colors.yellow;
    }

    notifyListeners();
  }
}

class _MyClientListener extends ClientListener {
  final LsClient _parent;

  _MyClientListener(this._parent);

  @override
  void onStatusChange(String status) {
    _parent._consumeMessage(status);
  }
}

class _MySubscriptionListener extends SubscriptionListener {
  final LsClient _parent;

  _MySubscriptionListener(this._parent);

  @override
  void onItemUpdate(ItemUpdate updateInfo) {
    _parent._consumeRTMessage(updateInfo);
  }
}