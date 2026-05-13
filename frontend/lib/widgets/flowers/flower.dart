import 'package:flutter/material.dart';

abstract class Flower extends StatelessWidget {
  const Flower({
    super.key,
    required this.frontImage,
    required this.backGround,
    required this.color,
  });
  final String frontImage;
  final String backGround;
  final Color color;

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
