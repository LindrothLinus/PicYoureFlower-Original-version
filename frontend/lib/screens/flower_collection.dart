import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/back_btn.dart';

class FlowerCollection extends StatelessWidget {
  const FlowerCollection({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flower Collection'),
          backgroundColor: const Color.fromARGB(255, 221, 25, 11),
          leading: CustomBackButton(),
        ),
        backgroundColor: const Color.fromARGB(255, 221, 99, 90),
      ),
    );
  }
}