import 'package:flutter/material.dart';
import 'package:flutter_demo/screens/Greenhouse.dart';
import 'package:flutter_demo/states/like_sent_overlay.dart';
import 'package:flutter_demo/widgets/add_button.dart';
import 'package:flutter_demo/widgets/like_button.dart';
import 'package:flutter_demo/widgets/like_sent.dart';

class ViewFriendScreen extends StatelessWidget {
  const ViewFriendScreen({
    super.key,
    required this.friendId,
    required this.addButtons,
  });

  final int friendId;
  final List<AddButton> addButtons;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: 70,
            right: 30,
            child: LikeButton(
              userId: 123,
              
            ), //hämta user från databasen!
          ),

         Greenhouse(addButtons: addButtons),
         LikeButton(userId: friendId)
        ],
      ),
    );
  }

  /*void showLikeButton() {
    LikedPopUp.showLikeSent(context);
  }*/
}
