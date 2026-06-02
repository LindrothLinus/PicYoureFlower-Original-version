import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/widgets/camera_feed.dart';
import 'package:flutter_demo/widgets/flowers/flower.dart';
import 'package:flutter_demo/widgets/flowers/genericflower.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import '../resources/constants.dart';
import '../screens/flower_info.dart';

String? authToken;
String? loggedInUserId;

class CameraButtonBar extends StatefulWidget {
  CameraButtonBar({super.key, required this.cameraFeed, required this.cameraKey, required this.isLoading});

  final CameraFeed cameraFeed;
  final GlobalKey<CameraFeedState> cameraKey;
  final ValueNotifier<bool> isLoading;

  @override
  State<CameraButtonBar> createState() => _CameraButtonBarState();
}

class _CameraButtonBarState extends State<CameraButtonBar> with SingleTickerProviderStateMixin {
  late AnimationController _spinController;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _spinController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _showSpinner(BuildContext context) {
    _spinController.repeat();
    _overlayEntry = OverlayEntry(
      builder: (_) => AbsorbPointer(
        absorbing: true,
        child: SizedBox.expand(
          child: Center(
            child: RotationTransition(
              turns: _spinController,
              child: Image.asset(
                PotImagePathConsts.blue,
                width: 80,
                height: 80,
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideSpinner() {
    _spinController.stop();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _printResults(Map<String, dynamic> decoded) {
    final List<dynamic>? results = decoded['results'] as List<dynamic>?;
    if (results != null && results.isNotEmpty) {
      for (int i = 0; i < results.length && i < 3; i++) {
        final r = results[i] as Map<String, dynamic>;
        final score = ((r['score'] as num?) ?? 0).toDouble();
        final sci = (r['species']?['scientificNameWithoutAuthor'] as String?) ?? 'Unknown';
        print('Match ${i + 1}: $sci | Probability: ${(score * 100).toStringAsFixed(1)}%');
      }
    }
  }

  Future<File> _cropToCenter(Uint8List bytes, String filename) async {
    final original = img.decodeImage(bytes)!;

    final cropW = (original.width * 0.5).toInt();
    final cropH = (original.height * 0.5).toInt();
    final startX = (original.width - cropW) ~/ 2;
    final startY = (original.height - cropH) ~/ 2;

    final cropped = img.copyCrop(original, x: startX, y: startY, width: cropW, height: cropH);

    final tempDir = await getTemporaryDirectory();
    final croppedFile = File('${tempDir.path}/$filename');
    await croppedFile.writeAsBytes(img.encodeJpg(cropped));
    return croppedFile;
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
      final uri = Uri.parse('${UrlConsts.flowerService}/home/identify');
      final request = http.MultipartRequest('POST', uri);

      final bytes = await image.readAsBytes();
      final croppedFile = await _cropToCenter(bytes, 'cropped_center.jpg');
      request.files.add(await http.MultipartFile.fromPath('image', croppedFile.path));

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
        final decoded = jsonDecode(responseBody) as Map<String, dynamic>;
        _printResults(decoded);
        return decoded;
      }
      return null;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.isLoading,
      builder: (context, isLoading, child) {
        return BottomAppBar(
          color: mainColor,
          child: Center(
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      widget.isLoading.value = true;
                      _showSpinner(context);

                      try {
                        //real camera
                        final XFile? image = await widget.cameraKey.currentState?.takePicture();
                        if (image == null) return;

                        final String? location = await _getLocationString()
                            .timeout(const Duration(seconds: 5), onTimeout: () => null);
                        print('Location result: $location');
                        //final data = await identifyTestImage(location: location);
                        final data = await identifyFlower(image, location: location)
                            .timeout(const Duration(seconds: 20), onTimeout: () => null);

                        if (!context.mounted) return;

                        final flower = data != null
                            ? Flower.buildFlower(data)
                            : GenericFlower(color: Colors.pink, name: 'Unknown');

                        try{
                          final response = await http.get(Uri.parse('${UrlConsts.userService}/home/addcoins/$loggedInUserId/5'));
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
                      } finally {
                        if (mounted) {
                          _hideSpinner();
                          widget.isLoading.value = false;
                        }
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
      },
    );
  }
}