import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/resources/constants.dart';
import 'package:flutter_demo/widgets/back_btn.dart';
import 'package:flutter_demo/widgets/camera_button.dart';
import '../widgets/camera_feed.dart';

class Camera extends StatelessWidget {
  const Camera({super.key});

  Future<CameraDescription> _getCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    return cameras.first;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<CameraFeedState> cameraKey = GlobalKey<CameraFeedState>();
    CameraFeed cameraFeed = CameraFeed(key:cameraKey);

    return Scaffold(
      body: Stack(children: [cameraFeed,CustomBackButton()],),
      
      backgroundColor: mainColor,
      bottomNavigationBar:CameraButtonBar(cameraFeed: cameraFeed,cameraKey: cameraKey,) ,

      
    );
  }



}
