import 'package:flutter/material.dart';

class Shop extends StatelessWidget {
  const Shop({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Shop'),
          backgroundColor: Colors.blue[900],
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }
}