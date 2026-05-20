import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/widgets/camera_feed.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../resources/constants.dart';
import '../screens/flower_info.dart';

String? authToken;
String? loggedInUserId;

class TemporaryFlowerItem {
  final String name;
  final String backGround;
  final String frontImage;
  final Color color;

  TemporaryFlowerItem({
    required this.name,
    required this.backGround,
    required this.frontImage,
    this.color = Colors.transparent,
  });
}

class CameraButtonBar extends StatelessWidget {
  CameraButtonBar({super.key, required this.cameraFeed, required this.cameraKey});

  final CameraFeed cameraFeed;
  final GlobalKey<CameraFeedState> cameraKey;

  Future<void> identifyFlower(XFile image) async {
    try {
      final uri = Uri.parse('https://group-1-75.pvt.dsv.su.se/home/identify');
      final request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('image', image.path));

      if (loggedInUserId != null) {
        request.fields['userId'] = loggedInUserId!;
      }
      if (authToken != null) {
        request.headers['Authorization'] = 'Bearer $authToken';
      }

      print('Sending request');
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print(response.statusCode);
      print(responseBody);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> identifyTestImage() async {
    try {
      final uri = Uri.parse('https://group-1-75.pvt.dsv.su.se/home/identify');

      final byteData = await rootBundle.load('lib/resources/images/testblomma.jpg');
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/testblomma.jpg');
      await tempFile.writeAsBytes(byteData.buffer.asUint8List());

      final request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('image', tempFile.path));

      if (loggedInUserId != null) {
        request.fields['userId'] = loggedInUserId!;
      }
      if (authToken != null) {
        request.headers['Authorization'] = 'Bearer $authToken';
      }

      print('Sending test image...');
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print(response.statusCode);
      print(responseBody);
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: mainColor,
      child: Center(
        child: ElevatedButton(
          onPressed: () async {
            await identifyTestImage();

            final dummyItem = TemporaryFlowerItem(
              name: "Dandelion",
              backGround: "lib/resources/images/VBSolros.png",
              frontImage: "lib/resources/images/Solros.png",
              color: Colors.yellow.withOpacity(0.3),
            );

            if (!context.mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FlowerInfoScreen(
                  flowerItem: dummyItem,
                ),
              ),
            );
          },
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