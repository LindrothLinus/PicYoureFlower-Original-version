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

const String _baseUrl = 'https://group-1-75.pvt.dsv.su.se';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  final String title = "PicYourFlower";

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late List<AddButton> _addButtons = [];
  late List<Pot> _pots = [];
  @visibleForTesting
  final Map<int, GlobalKey<AddButtonState>> addButtonKeys = {};
  final ValueNotifier<PotState?> _selectedPotNotifier = ValueNotifier<PotState?>(null);
  // Your branch: flowers now fetched from API instead of hardcoded
  List<Flower> _flowers = [RoseFlower(color: Colors.red, name: "r")];

  final List<({double x, double y})> _addButtoncordinates = [
    (x: 3000, y: 1400),
    (x: 2500, y: 1400),
    (x: 3000, y: 2150),
    (x: 2500, y: 2150),
    (x: 3000, y: 2850),
    (x: 2500, y: 2850),
    (x: 2000, y: 2850),
    (x: 3500, y: 2850),
    (x: 4000, y: 2850),
    (x: 1500, y: 2850),
  ];

  final buildModeActiveNotifier = ValueNotifier<bool>(false);
  final buildBarActiveNotifer = ValueNotifier<bool>(false);
  late BuildBar buildBar;

  final itemSelected = ValueNotifier<Widget?>(null);

  @override
  void initState() {
    super.initState();

    _iniPotsAndFlowerList();
    _addButtons = generateAddButtons(_addButtoncordinates);

    buildBar = BuildBar(
      flowers: _flowers,
      pots: _pots,
      visibilityNotifier: buildBarActiveNotifer,
      onFlowerSelected: (flower) {
        itemSelected.value = itemSelected.value != flower ? flower : null;
      },
      onPotSelected: (pot) {
        itemSelected.value = itemSelected.value != pot ? pot : null;
      },
    );

    

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadPotsOnAddButtonWithIndex([]);
    });
  }

  // Your branch: parse hex color string from backend
  @visibleForTesting
  Color parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return Colors.pink;
    try {
      return Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
    } catch (_) {
      return Colors.pink;
    }
  }

  // Your branch: map backend JSON to the correct Flower widget
  @visibleForTesting
  Flower buildFlower(Map<String, dynamic> data) {
    final String template = (data['template'] as String?) ?? 'GENERIC';
    final Color color = parseColor(data['color'] as String?);
    final String name = (data['commonName'] as String?) ?? 'Unknown';
    switch (template) {
      case 'ROSE':
        return RoseFlower(color: color, name: name);
      case 'SUNFLOWER':
        return SunFlower(color: color, name: name);
      case 'TULIP':
        return TulipFlower(color: color, name: name);
      case 'WOODANEMONE':
        return WoodanemoneFlower(color: color, name: name);
      default:
        return GenericFlower(color: color, name: name);
    }
  }

  // Your branch: fetch the logged-in user's flowers from the backend
  Future<void> _fetchFlowers() async {
    if (loggedInUserId == null) return;
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/home/user/$loggedInUserId/flowers'),
        headers: {if (authToken != null) 'Authorization': 'Bearer $authToken'},
      );
      if (response.statusCode == 200 && mounted) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _flowers = data
              .cast<Map<String, dynamic>>()
              .map(buildFlower)
              .toList();
          // Rebuild buildBar with fresh flowers
          buildBar = BuildBar(
            flowers: _flowers,
            pots: [
              Pot(
                item: itemSelected,
                buildBarActiveNotifer: buildBarActiveNotifer,
                selectedPotNotifier: _selectedPotNotifier,
              ),
            ],
            visibilityNotifier: buildBarActiveNotifer,
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title, style: TextStyles.header),
      ),
      body: Scaffold(
        body: Stack(
          children: [
            Greenhouse(addButtons: _addButtons),
            SafeArea(child: FriendMenu()),
          ],
        ),

        bottomSheet: buildBar,
      ),

      bottomNavigationBar: NavBar(
        onBuildModeButtonPressed: () {
          buildModeActiveNotifier.value = !buildModeActiveNotifier.value;
          print(extractPots());
        },
      ),
    );

    //test du kan ta bort denna komentar
  }


 void loadPotsOnAddButtonWithIndex(List<int> indexs){
  for (int i in indexs) {
    addButtonKeys[i]?.currentState?.setPot(
      Pot(
        item: itemSelected,
        buildBarActiveNotifer: buildBarActiveNotifer,
        selectedPotNotifier: _selectedPotNotifier,
      ),
    );
  }
 }



  List<({int index, Pot pot, Flower? flower})> extractPots() {
    List<({int index, Pot pot, Flower? flower})> data = [];
    for (int i = 0; i < addButtonKeys.length; i++) {
      Widget? potWidget = addButtonKeys[i]?.currentState?.getPot();
      if (potWidget is Pot) {
        Pot pot = potWidget;

        Widget? flowerWidgt = pot.getPlantedItem();
        if (flowerWidgt is Flower) {
          data.add((index: i, pot: pot, flower: flowerWidgt));
        } else {
          data.add((index: i, pot: pot, flower: null));
        }
      }
    }
    return data;
  }

  void _iniPotsAndFlowerList() {
    _pots = [
      Pot(
        item: itemSelected,
        buildBarActiveNotifer: buildBarActiveNotifer,
        selectedPotNotifier: _selectedPotNotifier,
      ),
    ];
    // Your branch: pass onSuccess so flowers load right after login
    WidgetsBinding.instance.addPostFrameCallback((_) {
      login_popup(context, onSuccess: _fetchFlowers);
    });
    // Your branch: also refresh when build mode opens
    buildModeActiveNotifier.addListener(() {
      if (buildModeActiveNotifier.value) _fetchFlowers();
    });
  }

  @visibleForTesting
  List<AddButton> generateAddButtons(final List<({double x, double y})> cordinates) {
    List<AddButton> buttons = List.generate(cordinates.length, (i) {
      final key = GlobalKey<AddButtonState>();
      addButtonKeys[i] = key;
      return AddButton(
        key: key,
        builModeActiveNotifier: buildModeActiveNotifier,
        buildBarActiveNotifer: buildBarActiveNotifer,
        x: cordinates[i].x,
        y: cordinates[i].y,
        item: itemSelected,
      );
    });
    
    return buttons;
  }
}
//test