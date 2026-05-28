import 'package:flutter/material.dart';

const String checkButtonPath =
    "lib/resources/images/Confirmed.png"; //Behöver göras ungefär dubbelt så stor

class CheckButton extends StatelessWidget {
  const CheckButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      checkButtonPath,
      width: 100,
      height: 100,
    );
  }
}