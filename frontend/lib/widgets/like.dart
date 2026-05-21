import 'package:flutter/material.dart';

const String likePath = "lib/resources/images/Like.png";

class LikeButton extends StatelessWidget {
  final String userId; //Den ska bara visas om man är på någon annans växthus
  final VoidCallback liked;

  const LikeButton({super.key, required this.userId, required this.liked});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: liked,
      child: Image.asset(likePath, height: 60, width: 60),
    );
  }
}
