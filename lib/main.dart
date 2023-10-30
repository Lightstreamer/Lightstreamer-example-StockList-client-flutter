import 'package:flutter/material.dart';
import 'app_stub.dart'
  if (dart.library.js) 'app_web.dart'
  if (dart.library.io) 'app_mobile.dart';

void main() {
  runApp(MyApp());
}