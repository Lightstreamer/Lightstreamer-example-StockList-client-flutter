import 'package:flutter/material.dart';
import 'package:lightstreamer_flutter_client/lightstreamer_flutter_client.dart';
import 'package:lightstreamer_flutter_demo/client_api.dart';

class LsClient extends ILsClient {
  String subId2 = "";
  String subId9 = "";

  bool get sub2IsActive => subId2 != "";
  bool get sub2IsSubscribed => sub2IsActive && name2 != "";
  bool get sub9IsActive => subId9 != "";
  bool get sub9IsSubscribed => sub9IsActive && name9 != "";

  LsClient() {
    LightstreamerFlutterClient.enableLog();
  }

  connect() async {
    if (clientStatus == "DISCONNECTED") {
      clientStatus = await LightstreamerFlutterClient.connect("https://push.lightstreamer.com/", "WELCOME", {}) ?? "UNKNOWN";
      LightstreamerFlutterClient.setClientListener(_consumeMessage);
    } else {
      clientStatus = await LightstreamerFlutterClient.disconnect() ?? "UNKNOWN";
      name2 = name9 = "";
    }

    notifyListeners();
  }

  subscribe(String item) async {
    if (item.startsWith("item2")) {
      if (subId2 == "") {
        Map<String, String> params = {
          "dataAdapter": "STOCKS",
          "requestedMaxFrequency": "7",
          "requestedSnapshot": "yes"
        };
        subId2 = await LightstreamerFlutterClient.subscribe(
          "MERGE",
          itemList: [item],
          fieldList: "last_price,time,stock_name".split(","),
          parameters: params
        ) ?? "";

        LightstreamerFlutterClient.setSubscriptionListener(subId2, _consumeRTMessage);
      } else {
        await LightstreamerFlutterClient.unsubscribe(subId2);
        subId2 = "";
      }
    } else {
      if (subId9 == "") {
        Map<String, String> params = {
          "dataAdapter": "STOCKS",
          "requestedMaxFrequency": "7",
          "requestedSnapshot": "yes"
        };
        subId9 = await LightstreamerFlutterClient.subscribe(
          "MERGE",
          itemList: [item],
          fieldList: "last_price,time,stock_name".split(","),
          parameters: params
        ) ?? "";

        LightstreamerFlutterClient.setSubscriptionListener(subId9, _consumeRTMessage);
      } else {
          await LightstreamerFlutterClient.unsubscribe(subId9);
          subId9 = "";
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