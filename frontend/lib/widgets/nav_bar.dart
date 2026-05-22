import 'package:flutter/material.dart';
import 'package:flutter_demo/screens/camera.dart';
import 'package:flutter_demo/screens/flower_collection.dart';

import '../resources/constants.dart';
import '../screens/shop.dart';

const String shopIconPath = "lib/resources/images/cart_icon.png";
const String buildmodeIconPath = "lib/resources/images/showel_icon.png";
const String cameraIconPath = "lib/resources/images/camera_icon.png";
const String flowerCollectionIconPath = "lib/resources/images/flower_icon.png";

class NavBar extends StatefulWidget {
  const NavBar({super.key, required this.onBuildModeButtonPressed});

  final Function() onBuildModeButtonPressed;

  @override
  NavBarState createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  bool visible = true;

  @override
  Widget build(BuildContext context) {
    final isCamera = ModalRoute.of(context)?.settings.name == '/camera';
    final isShop = ModalRoute.of(context)?.settings.name == '/shop';
    final isFlowerCollection =
        ModalRoute.of(context)?.settings.name == '/flower_collection';

    return Visibility(
      visible: true,

      child: BottomAppBar(
        color: mainColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Image.asset(shopIconPath),
              onPressed: isShop
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          settings: RouteSettings(name: '/shop'),
                          builder: (context) => Shop(),
                        ),
                      );
                    },
            ),
            IconButton(
              icon: Image.asset(buildmodeIconPath),
              onPressed: () {
                setState(() {
                  visible = false;
                });
                widget.onBuildModeButtonPressed();
              },
            ),
            IconButton(
              icon: Image.asset(cameraIconPath),
              onPressed: isCamera
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          settings: RouteSettings(name: '/camera'),
                          builder: (context) => Camera(),
                        ),
                      );
                    },
            ),
            IconButton(
              icon: Image.asset(flowerCollectionIconPath),
              onPressed: isFlowerCollection
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          settings: RouteSettings(name: '/flower_collection'),
                          builder: (context) => FlowerCollection(),
                        ),
                      );
                    },
            ),
          ],
        ),
      ),
    );
  }
}