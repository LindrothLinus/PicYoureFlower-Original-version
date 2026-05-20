import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/screens/Greenhouse.dart';
import 'package:flutter_demo/widgets/add_button.dart';
import 'package:flutter_demo/widgets/build_bar.dart';
import 'package:flutter_demo/widgets/camera_button.dart';
import 'package:flutter_demo/widgets/flowers/flower.dart';
import 'package:flutter_demo/widgets/flowers/genericflower.dart';
import 'package:flutter_demo/widgets/flowers/rose_flower.dart';
import 'package:flutter_demo/widgets/flowers/sunflower.dart';
import 'package:flutter_demo/widgets/flowers/tulip.dart';
import 'package:flutter_demo/widgets/flowers/woodanemone.dart';
import 'package:flutter_demo/widgets/friend_menu.dart';
import 'package:flutter_demo/widgets/login_popup.dart';
import 'package:flutter_demo/widgets/nav_bar.dart';
import 'package:flutter_demo/widgets/pots/blue_pot.dart';
import 'package:http/http.dart' as http;

import '../resources/constants.dart';

const String _baseUrl = 'http://10.0.2.2:8080';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  final String title = "PicYourFlower";

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // Your branch: flowers now fetched from API instead of hardcoded
  List<Flower> _flowers = [];

  final buildModeActiveNotifier = ValueNotifier<bool>(false);
  late BuildBar buildBar;

  final itemSelected = ValueNotifier<Widget?>(null);

  @override
  void initState() {
    List<Pot> pots = [Pot(item: itemSelected)];

    super.initState();

    // Your branch: pass onSuccess so flowers load right after login
    WidgetsBinding.instance.addPostFrameCallback((_) {
      login_popup(context, onSuccess: _fetchFlowers);
    });

    // Your branch: also refresh when build mode opens
    buildModeActiveNotifier.addListener(() {
      if (buildModeActiveNotifier.value) _fetchFlowers();
    });

    buildBar = BuildBar(
      flowers: _flowers,
      pots: pots,
      visibilityNotifier: buildModeActiveNotifier,
      onFlowerSelected: (flower) {
        if (flower != itemSelected.value) {
          itemSelected.value = flower;
        } else {
          itemSelected.value = null;
        }
        print(itemSelected.value);
      },
      onPotSelected: (pot) {
        if (itemSelected.value != pot) {
          itemSelected.value = pot;
        } else {
          itemSelected.value = null;
        }
        print(itemSelected.value);
      },
    );
  }

  // Your branch: parse hex color string from backend
  Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return Colors.pink;
    try {
      return Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
    } catch (_) {
      return Colors.pink;
    }
  }

  // Your branch: map backend JSON to the correct Flower widget
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

  // Your branch: fetch the logged-in user's flowers from the backend
  Future<void> _fetchFlowers() async {
    if (loggedInUserId == null) return;
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/home/user/$loggedInUserId/flowers'),
        headers: {
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      );
      if (response.statusCode == 200 && mounted) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _flowers = data.cast<Map<String, dynamic>>().map(_buildFlower).toList();
          // Rebuild buildBar with fresh flowers
          buildBar = BuildBar(
            flowers: _flowers,
            pots: [Pot(item: itemSelected)],
            visibilityNotifier: buildModeActiveNotifier,
            onFlowerSelected: (flower) {
              itemSelected.value = flower != itemSelected.value ? flower : null;
            },
            onPotSelected: (pot) {
              itemSelected.value = itemSelected.value != pot ? pot : null;
            },
          );
        });
      }
    } catch (e) {
      print('Error fetching flowers: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Main branch build() preserved exactly
    List<AddButton> addButtons = [
      AddButton(
        builModeActiveNotifier: buildModeActiveNotifier,
        x: 3000,
        y: 1400,
        item: itemSelected,
      ),
      AddButton(
        builModeActiveNotifier: buildModeActiveNotifier,
        x: 2500,
        y: 1400,
        item: itemSelected,
      ),
      AddButton(
        builModeActiveNotifier: buildModeActiveNotifier,
        x: 3000,
        y: 2150,
        item: itemSelected,
      ),
      AddButton(
        builModeActiveNotifier: buildModeActiveNotifier,
        x: 2500,
        y: 2150,
        item: itemSelected,
      ),
      AddButton(
        builModeActiveNotifier: buildModeActiveNotifier,
        x: 3000,
        y: 2850,
        item: itemSelected,
      ),
      AddButton(
        builModeActiveNotifier: buildModeActiveNotifier,
        x: 2500,
        y: 2850,
        item: itemSelected,
      ),
      AddButton(
        builModeActiveNotifier: buildModeActiveNotifier,
        x: 2000,
        y: 2850,
        item: itemSelected,
      ),
      AddButton(
        builModeActiveNotifier: buildModeActiveNotifier,
        x: 3500,
        y: 2850,
        item: itemSelected,
      ),
      AddButton(
        builModeActiveNotifier: buildModeActiveNotifier,
        x: 4000,
        y: 2850,
        item: itemSelected,
      ),
      AddButton(
        builModeActiveNotifier: buildModeActiveNotifier,
        x: 1500,
        y: 2850,
        item: itemSelected,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title, style: TextStyles.header),
      ),
      body: Scaffold(
        body: Stack(
          children: [
            Greenhouse(addButtons: addButtons),
            SafeArea(child: FriendMenu())
          ],
        ),

        bottomSheet: buildBar,
      ),

      bottomNavigationBar: NavBar(
        onBuildModeButtonPressed: () {
          buildModeActiveNotifier.value = !buildModeActiveNotifier.value;
        },
      ),
    );

    //test du kan ta bort denna komentar
  }
}
//test