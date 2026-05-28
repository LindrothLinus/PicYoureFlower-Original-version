import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/widgets/camera_feed.dart';
import 'package:flutter_demo/widgets/flowers/flower.dart';
import 'package:flutter_demo/widgets/flowers/genericflower.dart';
import 'package:flutter_demo/widgets/flowers/rose_flower.dart';
import 'package:flutter_demo/widgets/flowers/sunflower.dart';
import 'package:flutter_demo/widgets/flowers/tulip.dart';
import 'package:flutter_demo/widgets/flowers/woodanemone.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../resources/constants.dart';
import '../screens/flower_info.dart';

//const String _baseUrl = 'https://group-1-75.pvt.dsv.su.se';
const String _baseUrl = 'http://10.0.2.2:8080';

String? authToken;
String? loggedInUserId;

class CameraButtonBar extends StatelessWidget {
  CameraButtonBar({super.key, required this.cameraFeed, required this.cameraKey});

  final CameraFeed cameraFeed;
  final GlobalKey<CameraFeedState> cameraKey;

  Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return Colors.pink;
    try {
      return Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
    } catch (_) {
      return Colors.pink;
    }
  }

  Flower _buildFlower(Map<String, dynamic> data) {
    final String template = (data['template'] as String?) ?? 'GENERIC';
    final Color color = _parseColor(data['color'] as String?);
    final String name = (data['commonName'] as String?) ?? 'Unknown';
    switch (template) {
      case 'ROSE':        return RoseFlower(color: color, name: name);
      case 'SUNFLOWER':   return SunFlower(color: color, name: name);
      case 'TULIP':       return TulipFlower(color: color, name: name);
      case 'WOODANEMONE': return WoodanemoneFlower(color: color, name: name);
      default:            return GenericFlower(color: color, name: name);
    }
  }

  Future<String?> _getLocationString() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      if (permission == LocationPermission.deniedForever) return null;

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        List<String> parts = [
          if (place.subLocality != null && place.subLocality!.isNotEmpty)
            place.subLocality!,
          if (place.locality != null && place.locality!.isNotEmpty)
            place.locality!,
          if (place.country != null && place.country!.isNotEmpty)
            place.country!,
        ];
        return parts.isNotEmpty ? parts.join(', ') : null;
      }
      return null;
    } catch (e) {
      print('Location error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> identifyFlower(XFile image, {String? location}) async {
    try {
      final uri = Uri.parse('$flowerServiceUrl/home/identify');
      final request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('image', image.path));

      if (loggedInUserId != null) {
        request.fields['userId'] = loggedInUserId!;
      }
      if (location != null) {
        request.fields['location'] = location;
      }
      if (authToken != null) {
        request.headers['Authorization'] = 'Bearer $authToken';
      }

      print('Sending request');
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print(response.statusCode);
      print(responseBody);

      if (response.statusCode == 200) {
        return jsonDecode(responseBody) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> identifyTestImage({String? location}) async {
    try {
      final uri = Uri.parse('$flowerServiceUrl/home/identify');

      final byteData = await rootBundle.load('lib/resources/images/testblomma.jpg');
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/testblomma.jpg');
      await tempFile.writeAsBytes(byteData.buffer.asUint8List());

      final request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('image', tempFile.path));

      if (loggedInUserId != null) {
        request.fields['userId'] = loggedInUserId!;
      }
      if (location != null) {
        request.fields['location'] = location;
      }
      if (authToken != null) {
        request.headers['Authorization'] = 'Bearer $authToken';
      }

      print('Sending test image...');
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print(response.statusCode);
      print(responseBody);

      if (response.statusCode == 200) {
        return jsonDecode(responseBody) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: mainColor,
      child: Center(
        child: ElevatedButton(
          onPressed: () async {
            //real camera
            final XFile? image = await cameraKey.currentState?.takePicture();
            if (image == null) return;

            final String? location = await _getLocationString();
            print('Location result: $location');
            //final data = await identifyTestImage(location: location);
            final data = await identifyFlower(image, location: location);

            if (!context.mounted) return;

            final flower = data != null
                ? _buildFlower(data)
                : GenericFlower(color: Colors.pink, name: 'Unknown');

            try{
              final response = await http.get(Uri.parse('$userServiceUrl/home/addcoins/$loggedInUserId/5'));
              print(response.statusCode);
              print(response.body);
            }catch(e){
              print('Add coins Error: e');
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FlowerInfoScreen(
                  flowerItem: flower,
                  data: data,
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