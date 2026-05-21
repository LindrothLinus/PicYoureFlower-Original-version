import 'package:flutter/material.dart';

const String likePath = "lib/resources/images/Like.png";

class LikeButton extends StatelessWidget {
  final String userId; //Den ska bara visas om man är på någon annans växthus

  const LikeButton({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _likeSent(context),

      child: Image.asset(likePath, height: 30, width: 30),
    );
  }

  void _likeSent(BuildContext context){
    
  }

}
