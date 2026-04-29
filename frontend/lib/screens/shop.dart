import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/back_btn.dart';

class Shop extends StatelessWidget {
  const Shop({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Shop'),
          backgroundColor: Colors.blue[900],
          leading: CustomBackButton(),
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }
}