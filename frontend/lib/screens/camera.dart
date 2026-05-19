import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/resources/constants.dart';
import 'package:flutter_demo/widgets/back_btn.dart';
import 'package:flutter_demo/widgets/camera_button.dart';
import '../widgets/camera_feed.dart';

class Camera extends StatefulWidget {
  Camera({super.key});
  State<Camera> createState() => CameraState();
}

class CameraState extends State<Camera> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<CameraFeedState> cameraKey = GlobalKey<CameraFeedState>();
    CameraFeed cameraFeed = CameraFeed(key: cameraKey);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CustomBackButton(toHome: true),
      ),
      body: Center(child: cameraFeed),

      backgroundColor: mainColor,
      bottomNavigationBar: CameraButtonBar(
        cameraFeed: cameraFeed,
        cameraKey: cameraKey,
      ),
    );
  }
}
