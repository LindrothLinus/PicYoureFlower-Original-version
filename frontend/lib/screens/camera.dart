import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/back_btn.dart';

class Camera extends StatelessWidget {
  const Camera({super.key});


  Future<void> takePicture() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
  }

  @override
  Widget build(BuildContext context) {
 return Scaffold(
  appBar: AppBar(
          title: const Text('Camera'),
          backgroundColor: Colors.green,
          leading: CustomBackButton(),
        ),
        backgroundColor: Colors.greenAccent,
      );
  }
}


