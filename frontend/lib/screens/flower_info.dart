import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/back_btn.dart';
import 'package:flutter_demo/resources/constants.dart';
import 'dart:io';

class FlowerInfoScreen extends StatelessWidget {
  final String flowerName;
  final String imagePath;
  final String description;

  const FlowerInfoScreen({
    super.key,
    required this.flowerName,
    required this.imagePath,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(flowerName, style: TextStyles.header),
        backgroundColor: backgroundColor,
        leading: CustomBackButton(), // Bara tillbaka-knapp!
      ),
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Visar bilden du nyss tog
          Center(
            child: Image.file(File(imagePath), height: 250), 
          ),
          const SizedBox(height: 20),
          Text("Information", style: TextStyles.header),
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(description, style: TextStyles.body),
          ),
        ],
      ),
    );
  }
}