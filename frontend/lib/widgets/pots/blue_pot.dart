import 'package:flutter/material.dart';

class Pot extends StatefulWidget {
  Pot({super.key, required this.item});

  final ValueNotifier<Widget?> item;

  @override
  PotState createState() => PotState();
}

class PotState extends State<Pot> {
  bool isTaken = false;
  Widget? plantedItem;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.item,
      builder: (context, item, child) {
        return GestureDetector(
          onTap: () {
            if (item != null) {
              setState(() {
                isTaken = true;
                plantedItem = item;
              });
            }
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset("lib/resources/images/blue.webp"),
              Positioned(
                top:-100,
                left: -10,
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