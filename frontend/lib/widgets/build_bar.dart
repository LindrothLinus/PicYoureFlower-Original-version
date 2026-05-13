import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:flutter_demo/resources/constants.dart';
import 'package:flutter_demo/widgets/carousel.dart';

class BuildBar extends StatefulWidget {
  const BuildBar({super.key, required this.onFlowerSelected, required this.onPotSelected,required this.visibilityNotifier});

  final ValueNotifier<bool> visibilityNotifier;
  final Function(Widget) onFlowerSelected;
  final Function(Widget) onPotSelected;

  @override
  BuildBarState createState() => BuildBarState();
}

class BuildBarState extends State<BuildBar> {
  @override
  Widget build(BuildContext context) {
    const String flowerText = "  Youre Flowers:";
    const String potText = "  Youre Pots:";
    return ValueListenableBuilder<bool>(
      valueListenable: widget.visibilityNotifier, 
      builder: (context,isVisible,child){
        return Visibility(
      visible: isVisible,
      child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        color: Colors.blue,
      ),
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 0.5,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(flowerText),
            Carousel(onItemSelected: widget.onFlowerSelected,),
            Text(potText),
            Carousel(onItemSelected: widget.onPotSelected,),
          ],
        ),
      ),
    ));

      });
    
    
  }

}
