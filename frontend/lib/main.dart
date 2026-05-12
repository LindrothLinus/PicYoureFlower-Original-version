import 'package:flutter/material.dart';
import 'package:flutter_demo/screens/Greenhouse.dart';
import 'package:flutter_demo/widgets/login_popup.dart';
import 'package:flutter_demo/widgets/nav_bar.dart';
import 'package:flutter/services.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {

  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      login_popup(context);
    });
  }

  @override
  Widget build(BuildContext context){
    
    return Scaffold(

      body: Greenhouse(),
      bottomNavigationBar: NavBar()

    );

  }
}
