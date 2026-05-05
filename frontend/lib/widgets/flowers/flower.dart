import 'package:flutter/material.dart';

abstract class Flower extends StatelessWidget{
  Flower({super.key, required this.frontImage,required this.backGround,required this.color});
  final String frontImage;
  final String backGround;
  final Color color;

  
  
  @override
  Widget build(BuildContext context){
    return Stack(
      children: [
        Image.asset(backGround,color: color,),
        Image.asset(frontImage)]
    );

  } 
}