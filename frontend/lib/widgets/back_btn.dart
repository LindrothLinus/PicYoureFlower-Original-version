import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, required this.toHome});

  final bool toHome;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: () {
        if (toHome == true) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {
          Navigator.of(context, rootNavigator: true).pop();
        }
      },
    );
  }
}