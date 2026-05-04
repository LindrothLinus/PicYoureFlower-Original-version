import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/screens/camera.dart';
import 'package:flutter_demo/screens/flower_collection.dart';
import 'package:flutter_demo/widgets/camera_feed.dart';
import '../resources/constants.dart';
import '../screens/shop.dart';

class CameraButtonBar extends StatelessWidget {
  CameraButtonBar({super.key, required this.cameraFeed,required this.cameraKey});

  final CameraFeed cameraFeed;
  final GlobalKey<CameraFeedState>cameraKey;

  @override 
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: mainColor,
      child: Center(
        child: ElevatedButton(
          onPressed:(){cameraKey.currentState?.takePicture();},
          style: ElevatedButton.styleFrom(
            backgroundColor: blueColor,
            side: BorderSide(color: Colors.black, width: 2),
            shape: CircleBorder(),
            padding: EdgeInsets.all(40),
          ),
          child: SizedBox.shrink(),
        ),
      ),
    );
  }
}
