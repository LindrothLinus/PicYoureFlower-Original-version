import 'package:flutter/material.dart';
import 'package:flutter_demo/states/like_sent_overlay.dart';
import '../resources/constants.dart';

import 'package:http/http.dart' as http;

const String _baseUrl = 'http://10.0.2.2:8080';

const String likePath = "lib/resources/images/Like.png";

class LikeButton extends StatelessWidget {
  final int friendId; //Den ska bara visas om man är på någon annans växthus

  const LikeButton({super.key, required this.friendId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        sendLike();
        LikedPopUp.showLikeSent(context);
      },
      child: Image.asset(likePath, height: 60, width: 60),
    );
  }

  Future<void> sendLike() async {
    try {
      final response = await http.put(
        Uri.parse('$userServiceUrl/home/addlikes/$friendId/1'),
      );
    } catch (e) {
      print("server error: $e");
    }
  }
}
