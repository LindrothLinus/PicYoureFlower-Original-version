import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/back_btn.dart';
import 'package:flutter_demo/widgets/flower.dart';

class FlowerCollection extends StatelessWidget {
  FlowerCollection({super.key});

  Flower fl = Flower(color:Color.fromARGB(255, 2, 255, 27), 
          frontImage:"lib/resources/images/ros_sticker_kontur.png",
          backGround: "lib/resources/images/ros_sticker.png",);

  @override
  Widget build(BuildContext context) {
    
    
        return Scaffold(
        appBar: AppBar(
          title: const Text('Flower Collection'),
          backgroundColor: const Color.fromARGB(255, 221, 25, 11),
          leading: CustomBackButton(),
        ),

        
        body: fl,

        backgroundColor: const Color.fromARGB(255, 221, 99, 90),
      );
  }

  void setGreen(){
    fl.color=Colors.green;
    print("huuh");
  }
}