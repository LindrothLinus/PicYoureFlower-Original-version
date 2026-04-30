import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/back_btn.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
        backgroundColor: Colors.green,
        leading: CustomBackButton(),
      ),
      body: TakePictureScreen(),
      
      backgroundColor: Colors.greenAccent,
    );
  }
}
