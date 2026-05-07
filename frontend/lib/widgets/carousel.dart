import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/flowers/rose_flower.dart';
import 'package:flutter_demo/widgets/flowers/flower.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  CarouselState createState() => CarouselState();
}

class CarouselState extends State<Carousel> {
  @override
  Widget build(BuildContext context) {
    final List<Flower> flowers = [
      RoseFlower(color: Colors.red),
      RoseFlower(color: Colors.blue),
      RoseFlower(color: Colors.pink),
      RoseFlower(color: Colors.orange),
      RoseFlower(color: Colors.green),
      RoseFlower(color: Colors.deepPurpleAccent)
    ];
    return Expanded(
      child: ScrollConfiguration(
        behavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {...PointerDeviceKind.values},
        ),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (final Widget item in flowers)
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  margin: EdgeInsets.all(4.0),
                  padding: EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(
                      color: Colors.grey.withValues(alpha: 1),
                      
                      blurRadius: 1,
                      offset: Offset(1, 3),
                    )]
                  ),
                  child: Center(child: item),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
