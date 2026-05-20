import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/screens/flower_info.dart';
import 'package:flutter_demo/widgets/back_btn.dart';
import 'package:flutter_demo/widgets/camera_button.dart';
import 'package:flutter_demo/widgets/flowers/flower.dart';
import 'package:flutter_demo/widgets/flowers/genericflower.dart';
import 'package:flutter_demo/widgets/flowers/rose_flower.dart';
import 'package:flutter_demo/widgets/flowers/sunflower.dart';
import 'package:flutter_demo/widgets/flowers/tulip.dart';
import 'package:flutter_demo/widgets/flowers/woodanemone.dart';
import 'package:flutter_demo/widgets/nav_bar.dart';
import 'package:http/http.dart' as http;

import '../resources/constants.dart';

const String _baseUrl = 'http://10.0.2.2:8080';

// Your branch: StatefulWidget so we can fetch + show loading/error states
class FlowerCollection extends StatefulWidget {
  const FlowerCollection({super.key});

  @override
  State<FlowerCollection> createState() => _FlowerCollectionState();
}

class _FlowerCollectionState extends State<FlowerCollection> {
  // Your branch: dynamic list instead of hardcoded flowerCollection
  List<Flower> _flowers = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchFlowers();
    });
  }

  // Your branch: hex color parser
  Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return Colors.pink;
    try {
      return Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
    } catch (_) {
      return Colors.pink;
    }
  }

  // Your branch: map backend JSON to Flower widget
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

  // Your branch: fetch from backend with auth
  Future<void> _fetchFlowers() async {
    if (!mounted) return;
    setState(() { _isLoading = true; _error = null; });

    if (loggedInUserId == null) {
      if (!mounted) return;
      setState(() { _error = 'Not logged in'; _isLoading = false; });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/home/user/$loggedInUserId/flowers'),
        headers: {
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      );
      if (!mounted) return;
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _flowers = data.cast<Map<String, dynamic>>().map(_buildFlower).toList();
          _isLoading = false;
        });
      } else {
        setState(() { _error = 'Error ${response.statusCode}'; _isLoading = false; });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = 'Network error'; _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Main branch AppBar preserved exactly
      appBar: AppBar(
        title: Text('My flowers', style: TextStyles.header),
        backgroundColor: backgroundColor,
        leading: CustomBackButton(toHome: true),
      ),
      backgroundColor: backgroundColor,

      // Your branch: loading/error/empty states wrapping the main branch grid
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_error!, style: TextStyles.infoText),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _fetchFlowers,
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                )
              : _flowers.isEmpty
                  ? Center(
                      child: Text(
                        'No flowers yet!\nGo take some pictures 📸',
                        style: TextStyles.infoText,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _fetchFlowers,
                      // Main branch GridView + Card layout preserved exactly
                      child: GridView.builder(
                        padding: const EdgeInsets.all(20),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: _flowers.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = _flowers[index];

                          // Main branch GestureDetector + FlowerInfoScreen navigation preserved
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FlowerInfoScreen(flowerItem: item),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 5,
                              child: Stack(
                                children: [
                                  // Main branch: background image with color tint
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 25),
                                      child: SizedBox(
                                        height: 90,
                                        child: Image.asset(
                                          item.backGround,
                                          color: item.color,
                                          height: 90,
                                          width: 90,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Main branch: front image on top
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 25),
                                      child: SizedBox(
                                        height: 90,
                                        child: Image.asset(
                                          item.frontImage,
                                          height: 90,
                                          width: 90,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Main branch: name label at bottom preserved exactly
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      width: double.infinity,
                                      height: 30,
                                      padding: const EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        color: purpleColor,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(12),
                                          bottomRight: Radius.circular(12),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.name,
                                              style: TextStyles.infoText,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }, // Slut på itemBuilder
                      ),
                    ),

      // Main branch bottomNavigationBar preserved exactly
      bottomNavigationBar: NavBar(onBuildModeButtonPressed: () {}),
    );
  }
}