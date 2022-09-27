import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vexa_todo/Screens/Home/Views/home_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen()));
}
