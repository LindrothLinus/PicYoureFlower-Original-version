import 'package:flutter/material.dart';
import 'package:flutter_demo/resources/constants.dart';

class CheckButton extends StatelessWidget {
  const CheckButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ImagePaths.confirmed,
      width: 100,
      height: 100,
    );
  }
}