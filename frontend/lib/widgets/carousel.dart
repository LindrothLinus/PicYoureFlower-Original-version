import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/flowers/rose_flower.dart';
import 'package:flutter_demo/widgets/flowers/flower.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key, required this.onItemSelected,required this.items});

  final Function(Widget) onItemSelected;

  final List<Widget> items;

  @override
  CarouselState createState() => CarouselState();
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
            for (final Widget item in widget.items)
              AspectRatio(
                aspectRatio: 1,
                child: GestureDetector(
                  onTap:()=>widget.onItemSelected(item),
                  child: Container(
                    margin: EdgeInsets.all(4.0),
                    padding: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 1),

                          blurRadius: 1,
                          offset: Offset(1, 3),
                        ),
                      ],
                    ),
                    child: Center(child: AbsorbPointer( absorbing: true, child: item,)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
