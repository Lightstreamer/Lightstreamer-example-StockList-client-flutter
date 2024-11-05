import 'package:flutter/material.dart';
import 'package:lightstreamer_flutter_client/lightstreamer_client.dart';
import 'package:lightstreamer_flutter_demo/client_api.dart';

class LsClient extends ILsClient {
  bool get sub2IsActive => _sub2 != null;
  bool get sub2IsSubscribed => sub2IsActive && name2 != "";
  bool get sub9IsActive => _sub9 != null;
  bool get sub9IsSubscribed => sub9IsActive && name9 != "";

  // WARNING keep strong references to LightstreamerClients, Subscriptions, MpnDevices and MpnSubscriptions 
  // to receive related events
  LightstreamerClient _client;
  Subscription? _sub2, _sub9;

  LsClient() : _client = LightstreamerClient("https://push.lightstreamer.com/", "WELCOME") {
    _client.addListener(_MyClientListener(this));
    LightstreamerClient.setLoggerProvider(ConsoleLoggerProvider(ConsoleLogLevel.WARN));
  }

  connect() async {
    if (clientStatus == "DISCONNECTED") {
      await _client.connect();
      clientStatus = await _client.getStatus();
    } else {
      await _client.disconnect();
      name2 = name9 = "";
    }

    notifyListeners();
  }

  subscribe(String item) async {
    if (item.startsWith("item2")) {
      if (_sub2 == null) {
        var sub = Subscription("MERGE", [item], ["last_price", "time", "stock_name"]);
        sub.setDataAdapter("STOCKS");
        sub.setRequestedSnapshot("yes");
        sub.setRequestedMaxFrequency("7");
        sub.addListener(_MySubscriptionListener(this));
        _sub2 = sub;
        await _client.subscribe(sub);
      } else {
        var sub = _sub2!;
        _sub2 = null;
        await _client.unsubscribe(sub);
      }
    } else {
      if (_sub9 == null) {
        var sub = Subscription("MERGE", [item], ["last_price", "time", "stock_name"]);
        sub.setDataAdapter("STOCKS");
        sub.setRequestedSnapshot("yes");
        sub.setRequestedMaxFrequency("7");
        sub.addListener(_MySubscriptionListener(this));
        _sub9 = sub;
        await _client.subscribe(sub);
      } else {
        var sub = _sub9!;
        _sub9 = null;
        await _client.unsubscribe(sub);
      }
    }

    notifyListeners();
  }

  _consumeMessage(String status) {
    if (status.startsWith("StatusChange:")) {
      String currentStatus = status.split(":")[1];
      clientStatus = currentStatus;
      if (clientStatus.startsWith("CONNECTED")) {
        statusColor = Colors.green;
      } else if (clientStatus.startsWith("DISCONNECTED")) {
        statusColor = Colors.red;
      } else if (clientStatus.startsWith("CONNECTING")) {
        statusColor = Colors.orange;
      }
    }

    notifyListeners();
  }

  _consumeRTMessage(String item, String fieldName, String fieldValue) {
    if (item.startsWith("item2")) {
      if (fieldName.startsWith("last_price")) {
        last2 = fieldValue;
      } else if (fieldName.startsWith("time")) {
        time2 = fieldValue;
      } else if (fieldName.startsWith("stock_name")) {
        name2 = fieldValue;
      }
      highlightColor2 = Colors.yellow;
    } else if (item.startsWith("item9")) {
      if (fieldName.startsWith("last_price")) {
        last9 = fieldValue;
      } else if (fieldName.startsWith("time")) {
        time9 = fieldValue;
      } else if (fieldName.startsWith("stock_name")) {
        name9 = fieldValue;
      }
      highlightColor9 = Colors.yellow;
    }

    notifyListeners();
  }
}

class _MyClientListener extends ClientListener {
  final LsClient _client;
  _MyClientListener(this._client);

  @override
  void onStatusChange(String status) {
    _client._consumeMessage("StatusChange:$status");
  }
}

class _MySubscriptionListener extends SubscriptionListener {
  final LsClient _client;
  _MySubscriptionListener(this._client);

  @override
  void onItemUpdate(ItemUpdate update) {
    var item = update.getItemName() ?? "";
    for (var e in update.getChangedFields().entries) {
      _client._consumeRTMessage(item, e.key, e.value ?? "");
    }
  }
}