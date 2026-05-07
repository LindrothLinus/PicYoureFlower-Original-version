import 'dart:ui';

import 'package:flutter/material.dart';

class Carousel extends StatefulWidget{
  const Carousel({super.key});

  @override
  CarouselState  createState() => CarouselState();
}

class CarouselState extends State<Carousel> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
            child: ScrollConfiguration(
              behavior: const MaterialScrollBehavior().copyWith(
                dragDevices: {...PointerDeviceKind.values},
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final Color color in Colors.primaries)
                    AspectRatio(aspectRatio: 1,child: Container(color: color,),)
                ],
              ),
            ),
          );
  }
  
}