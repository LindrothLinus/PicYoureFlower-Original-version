import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/back_btn.dart';
import 'package:flutter_demo/widgets/flowers/flower.dart';
import 'package:flutter_demo/widgets/flowers/rose_flower.dart';
import 'package:flutter_demo/widgets/nav_bar.dart';

class FlowerCollection extends StatefulWidget {
  FlowerCollection({super.key});


  State<FlowerCollection> createState()=>FlowerCollectionState();

}

class FlowerCollectionState extends State<FlowerCollection>{

  //!Alt detta är debug kod som går att ta bort
  Color flowerColor = Colors.orange;
  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Flower Collection'),
            backgroundColor: const Color.fromARGB(255, 221, 25, 11),
            leading: CustomBackButton(),
          ),

          body: RoseFlower(color: flowerColor),

          bottomNavigationBar: IconButton(onPressed: (){setState(() {
            changeColor();
          });}, icon: Icon(Icons.abc)),

          backgroundColor: const Color.fromARGB(255, 221, 99, 90),
        );
    }

    void changeColor(){
      if(flowerColor==Colors.green){
        flowerColor = Colors.blue;
      }
      else{
        flowerColor=Colors.green;
      }
    }
  
}