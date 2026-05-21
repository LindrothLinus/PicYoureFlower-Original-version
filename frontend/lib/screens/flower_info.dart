import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/back_btn.dart';
import 'package:flutter_demo/resources/constants.dart';

class FlowerInfoScreen extends StatelessWidget {
  final dynamic flowerItem; 

  const FlowerInfoScreen({super.key, required this.flowerItem});
  static const String calendarIcon = "lib/resources/images/Calendar_v2.png";
  static const String identityIcon = "lib/resources/images/Identity.png";
  static const String locationIcon = "lib/resources/images/Location_v2.png";

  @override
  Widget build(BuildContext context) {
    final lightBlueBg = const Color(0xffbce3fc);
    final infoPurple = const Color(0xffd5bbf7);
    
    final blackBorder = Border.all(color: Colors.black, width: 1.5);
    final standardRadius = BorderRadius.circular(12);

    return Scaffold(
      backgroundColor: lightBlueBg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  CustomBackButton(toHome: false),
                  const SizedBox(width: 12),
                  Text(
                    flowerItem.name,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w300, 
                      fontStyle: FontStyle.italic,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 140,
                          width: 140,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: standardRadius,
                            border: blackBorder,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                flowerItem.backGround,
                                color: flowerItem.color,
                                fit: BoxFit.contain,
                              ),
                              Image.asset(
                                flowerItem.frontImage,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SizedBox(
                            height: 140, 
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildInfoRow("26-05-05", calendarIcon, infoPurple, blackBorder, standardRadius), 
                                _buildInfoRow("Taraxacum", identityIcon, infoPurple, blackBorder, standardRadius),
                                _buildInfoRow("Järvafältet", locationIcon, infoPurple, blackBorder, standardRadius),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      "Taraxacums a genus of flowering plants in the family Asteraceae, which consists of species commonly known as dandelions. The scientific and hobby study of the genus is known as taraxacology.",
                      style: TextStyle(fontSize: 18, color: Colors.black87, height: 1.3),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "The genus has a near-cosmopolitan distribution, absent only from tropical and polar areas. Two of the most common species worldwide, T. officinale (the common dandelion) and T.",
                      style: TextStyle(fontSize: 18, color: Colors.black87, height: 1.3),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String text, dynamic iconOrAsset, Color badgeColor, BoxBorder border, BorderRadius radius) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: radius,
        border: border,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.only(topLeft: radius.topLeft, bottomLeft: radius.bottomLeft),
              border: Border(right: border.top), 
            ),
            child: iconOrAsset is String 
              ? Image.asset(iconOrAsset, fit: BoxFit.contain)
              : Icon(iconOrAsset as IconData, size: 20, color: Colors.black87),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                text,
                style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}