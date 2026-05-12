import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraFeed extends StatefulWidget {
  const CameraFeed({super.key});

  @override
  CameraFeedState createState() => CameraFeedState();
}

class CameraFeedState extends State<CameraFeed> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = initCamera();
  }

  Future<void> initCamera() async{
    final cameras = await availableCameras();
    _controller = CameraController(cameras.first, ResolutionPreset.ultraHigh);
    await _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CameraPreview(_controller);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<XFile?> takePicture() async{
    try{
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      print(image.path);
      return image;
    }catch(e){
      print(e);
      return null;
    }

  }
}
