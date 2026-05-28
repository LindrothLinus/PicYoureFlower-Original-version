import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/flowers/genericflower.dart';
import 'package:flutter_demo/widgets/flowers/rose_flower.dart';
import 'package:flutter_demo/widgets/flowers/sunflower.dart';
import 'package:flutter_demo/widgets/flowers/tulip.dart';
import 'package:flutter_demo/widgets/flowers/woodanemone.dart';

abstract class Flower extends StatelessWidget {
  const Flower({
    super.key,
    required this.frontImage,
    required this.backGround,
    required this.color,
    required this.name,
    this.id,
  });
  final String frontImage;
  final String backGround;
  final Color color;
  final String name;
  final int? id;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 75,
      height: 75,
      child: Stack(
        children: [
          Image.asset(backGround, color: color, fit: BoxFit.contain),
          Image.asset(frontImage, fit: BoxFit.contain),
        ],
      ),
    );
  }

  
  static Flower buildFlower(Map<String, dynamic> data) {
    final String template = (data['template'] as String?) ?? 'GENERIC';
    final Color color = parseColor(data['color'] as String?);
    final String name = (data['commonName'] as String?) ?? 'Unknown';
    final int? id = (data['id'] as num?)?.toInt();
    switch (template) {
      case 'ROSE':
        return RoseFlower(color: color, name: name, id: id);
      case 'SUNFLOWER':
        return SunFlower(color: color, name: name, id: id);
      case 'TULIP':
        return TulipFlower(color: color, name: name, id: id);
      case 'WOODANEMONE':
        return WoodanemoneFlower(color: color, name: name, id: id);
      default:
        return GenericFlower(color: color, name: name, id: id);
    }
  }

  
  static parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return Colors.pink;
    try {
      return Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
    } catch (_) {
      return Colors.pink;
    }
  }
}