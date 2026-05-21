import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/back_btn.dart';
import 'package:http/http.dart' as http;

class FlowerInfoScreen extends StatefulWidget {
  final dynamic flowerItem;
  final Map<String, dynamic>? data;

  const FlowerInfoScreen({super.key, required this.flowerItem, this.data});

  @override
  State<FlowerInfoScreen> createState() => _FlowerInfoScreenState();
}

class _FlowerInfoScreenState extends State<FlowerInfoScreen> {
  static const String calendarIcon = "lib/resources/images/Calendar_v2.png";
  static const String identityIcon = "lib/resources/images/Identity.png";
  static const String locationIcon = "lib/resources/images/Location_v2.png";
  static const String _baseUrl = 'https://group-1-75.pvt.dsv.su.se';

  String _wikiText = '';
  bool _loadingWiki = true;

  @override
  void initState() {
    super.initState();
    _fetchWiki();
  }

  Future<void> _fetchWiki() async {
    final commonName = (widget.data?['commonName'] as String?)
        ?? widget.flowerItem?.name?.toString()
        ?? '';
    final latinName = (widget.data?['latinName'] as String?) ?? '';
    try {
      final uri = Uri.parse(
        '$_baseUrl/home/wikiinfo/${Uri.encodeComponent(commonName)}',
      ).replace(
        queryParameters:
            latinName.isNotEmpty
                ? {'latinName': latinName}
                : null,
      );
      final response = await http.get(uri);
      if (mounted) {
        String text = response.body;
        try {
          final decoded = jsonDecode(text);
          if (decoded is String) text = decoded;
        } catch (_) {}
        setState(() {
          _wikiText = response.statusCode == 200 ? text : '';
          _loadingWiki = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() { _loadingWiki = false; });
    }
  }

  String _formatDate(dynamic picTaken) {
    if (picTaken == null) return '—';
    if (picTaken is List && picTaken.length >= 3) {
      final y = picTaken[0].toString().substring(2);
      final m = picTaken[1].toString().padLeft(2, '0');
      final d = picTaken[2].toString().padLeft(2, '0');
      return '$y-$m-$d';
    }
    try {
      final parts = picTaken.toString().split('T')[0].split('-');
      if (parts.length >= 3) return '${parts[0].substring(2)}-${parts[1]}-${parts[2]}';
    } catch (_) {}
    return picTaken.toString();
  }

  @override
  Widget build(BuildContext context) {
    final lightBlueBg = const Color(0xffbce3fc);
    final lightPinkBg = const Color(0xfffcd3e4);
    final infoPurple = const Color(0xffd5bbf7);
    final blackBorder = Border.all(color: Colors.black, width: 1.5);
    final standardRadius = BorderRadius.circular(12);

    final dateStr = _formatDate(widget.data?['picTaken']);
    final latinName = (widget.data?['latinName'] as String?) ?? '—';

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
                    widget.flowerItem.name,
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
                                widget.flowerItem.backGround,
                                color: widget.flowerItem.color,
                                fit: BoxFit.contain,
                              ),
                              Image.asset(
                                widget.flowerItem.frontImage,
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
                                _buildInfoRow(dateStr, calendarIcon, infoPurple, blackBorder, standardRadius),
                                _buildInfoRow(latinName, identityIcon, infoPurple, blackBorder, standardRadius),
                                _buildInfoRow('—', locationIcon, infoPurple, blackBorder, standardRadius),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _loadingWiki
                        ? const Center(child: CircularProgressIndicator())
                        : Text(
                            _wikiText.isEmpty ? 'No description available.' : _wikiText,
                            style: const TextStyle(fontSize: 18, color: Colors.black87, height: 1.3),
                          ),
                  ],
                ),
              ),
            ),
            Container(
              color: lightPinkBg,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBottomIcon(Icons.shopping_cart_outlined),
                  _buildBottomIcon(Icons.hardware_outlined),
                  _buildBottomIcon(Icons.camera_alt_outlined),
                  _buildBottomIcon(Icons.yard_outlined),
                ],
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

  Widget _buildBottomIcon(IconData icon) {
    return IconButton(
      icon: Icon(icon, size: 36, color: Colors.black87),
      onPressed: () {},
    );
  }
}