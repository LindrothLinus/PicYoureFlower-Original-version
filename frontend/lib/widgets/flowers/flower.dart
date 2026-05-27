import 'package:flutter/material.dart';

abstract class Flower extends StatelessWidget {
  const Flower({
    super.key,
    required this.frontImage,
    required this.backGround,
    required this.color,
    required this.name,
    this.id,
  });
  final String frontImage;
  final String backGround;
  final Color color;
  final String name;
  final int? id;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 75,
      height: 75,
      child: Stack(
        children: [
          Image.asset(backGround, color: color, fit: BoxFit.contain),
          Image.asset(frontImage, fit: BoxFit.contain),
        ],
      ),
    );
  }
}