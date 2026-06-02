import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/screens/home_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen()));
}


//test