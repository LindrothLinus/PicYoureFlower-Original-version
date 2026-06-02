import 'package:flutter/material.dart';
import 'package:flutter_demo/resources/constants.dart';
import 'package:flutter_demo/states/like_sent_overlay.dart';
import 'package:http/http.dart' as http;


class LikeButton extends StatelessWidget {
  final int friendId; //Den ska bara visas om man är på någon annans växthus
  

  const LikeButton({super.key, required this.friendId,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        sendLike();
        LikedPopUp.showLikeSent(context);
      }
      ,
      child: Image.asset(ImagePathsConsts.likeIcon, height: 60, width: 60),
    );
  }



    Future<void> sendLike() async {
    try {
      final response = await http.put(Uri.parse('${UrlConsts.userService}/home/addlikes/$friendId/1'));
      }
    catch (e) {
      print("server error: $e");
    }
  }
}
