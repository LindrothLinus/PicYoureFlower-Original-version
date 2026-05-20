import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/flowers/flower.dart';

class Pot extends StatefulWidget {
  Pot({super.key, required this.item, required this.buildBarActiveNotifer});

  final ValueNotifier<Widget?> item;
  final ValueNotifier<bool> buildBarActiveNotifer;
  bool selected=false;

  @override
  PotState createState() => PotState();
}

class PotState extends State<Pot> {
  bool isTaken = false;
  Widget? plantedItem;

  @override
  void initState() {
    widget.item.addListener(
      (){
        if (widget.item.value != null && widget.item.value is Flower) {
              
                isTaken = true;
                plantedItem = widget.item.value;
                widget.item.value=null;
                widget.buildBarActiveNotifer.value=false;

              
        }
      
    }
  );}

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.item,
      builder: (context, item, child) {
        return GestureDetector(
          onTap: () {
            widget.selected=true;
            widget.buildBarActiveNotifer.value=true;

            
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              
              Image.asset("lib/resources/images/blue.webp", fit: BoxFit.fill,),
              Positioned(
                top:-60,
                left: 0,
                right: 0,
                child: plantedItem ?? Container(),
              ),
            ],
          ),
        );
      },
    );
  }
}