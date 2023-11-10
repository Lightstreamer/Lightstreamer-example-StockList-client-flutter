import 'package:flutter/material.dart';

abstract class ILsClient extends ChangeNotifier {
  String clientStatus = "DISCONNECTED";
  Color statusColor = Colors.red;

  String name2 = "";
  String time2 = "";
  String last2 = "";
  Color highlightColor2 = Colors.blueGrey;

  String name9 = "";
  String time9 = "";
  String last9 = "";
  Color highlightColor9 = Colors.blueGrey;

  bool get sub2IsActive => false;
  bool get sub2IsSubscribed => false;
  
  bool get sub9IsActive => false;
  bool get sub9IsSubscribed => false;

  void connect() {}
  void subscribe(String item) {}
}