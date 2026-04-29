import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/back_btn.dart';

class Camera extends StatelessWidget {
  const Camera({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( //tror eventuellt det här kan bli problem med navigationen, ta bort? tror bara vi vill returnera en ny i main
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Camera'),
          backgroundColor: Colors.green,
          leading: CustomBackButton(),
        ),
        backgroundColor: Colors.greenAccent,
      ),
    );
  }
}