import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/add_button.dart';
import 'package:flutter_demo/widgets/friend_menu.dart';
import 'package:flutter_demo/widgets/like.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_demo/states/like_sent_overlay.dart';

const String likedPath = "lib/resources/images/SentLike.png";

class Greenhouse extends StatefulWidget {
  const Greenhouse({super.key, required this.addButtons});
  final List<AddButton> addButtons;

  @override
  State<Greenhouse> createState() => _Greenhouse();
}

class _Greenhouse extends State<Greenhouse> {
  final TransformationController controller = TransformationController();
  final double imageWidth = 5906;
  final double imageHeight = 4725;
  final double scale = 0.17;

  @override
  void initState() {
    super.initState();

    controller.value = Matrix4.diagonal3Values(scale, scale, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final String greenhouseOwnerId = "myID";
    final String currentUserId =
        "myID"; //OBS Nu satt som samma eftersom det inte ska visas, behövas kopplas med backend

    final bool isOtherUsersGreenhouse = greenhouseOwnerId != currentUserId;

    return Scaffold(
      body: Stack(
        children: [
          InteractiveViewer(
            alignment: Alignment.topLeft,
            constrained: false,
            boundaryMargin: EdgeInsets.zero,
            clipBehavior: Clip.none,
            panEnabled: true,
            scaleEnabled: false,
            panAxis: PanAxis.free,
            interactionEndFrictionCoefficient: 0.00001,

            transformationController: controller,
            child: SizedBox(
              width: imageWidth,
              height: imageHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: SvgPicture.asset(
                      "lib/resources/images/Greenhouse.svg",
                    ),
                  ),
                  ...widget.addButtons,

                  //FriendMenu(),
                ],
              ),
            ),
          ),
          if (isOtherUsersGreenhouse)
            Positioned(
              bottom: 70,
              right: 30,
              child: LikeButton(
                userId: "123",
                liked: showLikeButton,
              ), //hämta user från databasen!
            ),
        ],
      ),
    );
  }

  void showLikeButton() {
    LikedPopUp.showLikeSent(context);
  }
}
