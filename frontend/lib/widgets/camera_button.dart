import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/screens/camera.dart';
import 'package:flutter_demo/screens/flower_collection.dart';
import 'package:flutter_demo/widgets/camera_feed.dart';
import '../resources/constants.dart';
import '../screens/shop.dart';
import 'package:http/http.dart' as http;
import '../screens/flower_info.dart';

// En temporär klass för att paketera data 
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

  Future<void> identifyFlower(XFile image, String owner) async {
    try {
<<<<<<< HEAD
      final uri = Uri.parse('https://group-1-75.pvt.dsv.su.se/home/identifyflower');
      final request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      print('Sending request'); 
=======
      //final uri = Uri.parse('http://192.168.0.10:8080/home/identifyflower'); //for testing locally
      //final uri = Uri.parse('https://group-1-75.pvt.dsv.su.se/home/identifyflower');
      final uri = Uri.parse('https://group-1-75.pvt.dsv.su.se/home/fromcamera');
      final request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      request.fields['owner'] = owner;
      print('Sending request'); //For debugging
>>>>>>> origin/main
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
            final image = await cameraKey.currentState?.takePicture();
            if (image != null) {
<<<<<<< HEAD
              await identifyFlower(image, "testusername");

            
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
=======
>>>>>>> origin/main
            }
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