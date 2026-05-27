import 'package:flutter/material.dart';

const String likePath = "lib/resources/images/Like.png";

class LikeButton extends StatelessWidget {
  final int userId; //Den ska bara visas om man är på någon annans växthus
  

  const LikeButton({super.key, required this.userId,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: sendLike,
      child: Image.asset(likePath, height: 60, width: 60),
    );
  }


  void sendLike(){
    
  }
}