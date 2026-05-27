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

const String _baseUrl = 'https://group-1-75.pvt.dsv.su.se';

class FlowerCollection extends StatefulWidget {
  const FlowerCollection({super.key});

  @override
  State<FlowerCollection> createState() => _FlowerCollectionState();
}

class _FlowerCollectionState extends State<FlowerCollection> {
  List<Flower> _flowers = [];
  List<Map<String, dynamic>> _flowerData = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchFlowers();
    });
  }

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
        final List<dynamic> raw = jsonDecode(response.body);
        final maps = raw.cast<Map<String, dynamic>>();
        setState(() {
          _flowerData = maps;
          _flowers = maps.map(_buildFlower).toList();
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
      appBar: AppBar(
        title: Text('My flowers', style: TextStyles.header),
        backgroundColor: backgroundColor,
        leading: CustomBackButton(toHome: true),
      ),
      backgroundColor: backgroundColor,

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

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FlowerInfoScreen(
                                    flowerItem: item,
                                    data: _flowerData[index],
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 5,
                              child: Stack(
                                children: [
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
                        },
                      ),
                    ),

      bottomNavigationBar: NavBar(onBuildModeButtonPressed: () {}),
    );
  }
}