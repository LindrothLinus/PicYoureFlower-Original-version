import 'package:flutter/material.dart';

const String likedPath =
    "lib/resources/images/SentLike.png"; //Behöver göras ungefär dubbelt så stor

class LikeSent extends StatelessWidget {
  const LikeSent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: Image.asset(likedPath, fit: BoxFit.contain),
      ),
    );
  }
}