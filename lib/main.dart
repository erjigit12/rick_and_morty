import 'package:flutter/material.dart';
import 'package:rick_morty/locator_service.dart' as di;
import 'package:rick_morty/src/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}
