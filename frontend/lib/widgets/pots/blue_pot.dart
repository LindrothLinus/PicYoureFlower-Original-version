import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/flowers/flower.dart';

class Pot extends StatefulWidget {
  Pot({super.key, required this.item});

  final ValueNotifier<Widget?> item;

  Widget? plantedItem;
  @override
  PotState createState() => PotState();

  Widget? getPlantedItem(){
    return plantedItem;
  }
}

class PotState extends State<Pot> {
  bool isTaken = false;
  

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.item,
      builder: (context, item, child) {
        return GestureDetector(
          onTap: () {
            if (item != null && item is Flower) {
              setState(() {
                isTaken = true;
                widget.plantedItem = item;
              });
            }
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              
              Image.asset("lib/resources/images/blue.webp", fit: BoxFit.fill,),
              Positioned(
                top:-60,
                left: 0,
                right: 0,
                child: widget.plantedItem ?? Container(),
              ),
            ],
          ),
        );
      },
    );
  }
}