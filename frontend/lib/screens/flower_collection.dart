import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/back_btn.dart';
import 'package:flutter_demo/widgets/flowers/flower.dart';
import 'package:flutter_demo/widgets/flowers/rose_flower.dart';

class FlowerCollection extends StatelessWidget {
  FlowerCollection({super.key});

  @override
  Widget build(BuildContext context) {
    
    
        return Scaffold(
        appBar: AppBar(
          title: const Text('Flower Collection'),
          backgroundColor: const Color.fromARGB(255, 221, 25, 11),
          leading: CustomBackButton(),
        ),

        body:RoseFlower(color:Colors.black),
        

        backgroundColor: const Color.fromARGB(255, 221, 99, 90),
      );
  }
}