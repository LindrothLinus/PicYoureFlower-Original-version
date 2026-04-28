import 'package:flutter/material.dart';


class Camera extends StatelessWidget {
  const Camera({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Camera'),
          backgroundColor: Colors.green,
        ),
        backgroundColor: Colors.greenAccent,
      ),
    );
  }
}