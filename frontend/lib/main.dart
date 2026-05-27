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
  const MyApp({super.key, this.httpClient});

  //!För mockramverk annars ska denna vara lämnas null
  final http.Client? httpClient;
  final String title = "PicYourFlower";

  @override
  State<MyApp> createState() => MyAppState(httpClient: httpClient);
}

class MyAppState extends State<MyApp> {

  MyAppState({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;
  late List<AddButton> _addButtons = [];
  late List<Pot> _pots = [];
  @visibleForTesting
  final Map<int, GlobalKey<AddButtonState>> addButtonKeys = {};
  final ValueNotifier<PotState?> _selectedPotNotifier = ValueNotifier<PotState?>(null);
  // Your branch: flowers now fetched from API instead of hardcoded
  @visibleForTesting
  List<Flower> flowerCollection = [];

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

  final Map<int, String> _slotPotTemplates = {};
  final Map<int, int?> _slotFlowerIds = {};
  final Set<int> _placedFlowerIds = {};
  final Map<int, int?> _slotPotIds = {};
  final Set<int> _placedPotIds = {};
  bool _greenhouseLoaded = false;

  @override
  void initState() {
    super.initState();

    _iniPotsAndFlowerList();
    _addButtons = generateAddButtons(_addButtoncordinates);

    buildBar = BuildBar(
      flowers: flowerCollection,
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

  void _rebuildBuildBar() {
    buildBar = BuildBar(
      flowers: flowerCollection
          .where((f) => f.id == null || !_placedFlowerIds.contains(f.id))
          .toList(),
      //pots: [Pot(item: itemSelected, buildBarActiveNotifer: buildBarActiveNotifer, selectedPotNotifier: _selectedPotNotifier)],
      pots: _pots
        .where((p) => p.id == null || !_placedPotIds.contains(p.id)).toList(),
      visibilityNotifier: buildBarActiveNotifer,
      onFlowerSelected: (flower) {
        itemSelected.value = itemSelected.value != flower ? flower : null;
      },
      onPotSelected: (pot) {
        itemSelected.value = itemSelected.value != pot ? pot : null;
      },
    );
  }

  // Your branch: fetch the logged-in user's flowers from the backend
  @visibleForTesting
  Future<void> fetchFlowers() async {
    if (loggedInUserId == null) return;
    try {
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/home/user/$loggedInUserId/flowers'),
        headers: {if (authToken != null) 'Authorization': 'Bearer $authToken'},
      );
      if (response.statusCode == 200 && mounted) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          flowerCollection = data
              .cast<Map<String, dynamic>>()
              .map(buildFlower)
              .toList();
          _rebuildBuildBar();
        });
        await _loadGreenhouse();
      }
    } catch (e) {
      print('Error fetching flowers: $e');
    }
  }

  Pot? _buildPot(Map<String, dynamic> data){
    //double check what field these are supposed to be
    final int? id = (data['id'] as num)?.toInt();
    final String color = data['pots'] as String;
    final bool placedPot = data['placed'] as bool;
    if(placedPot) return null;
    switch(color){
      case 'BLUE':        return Pot(item: itemSelected, buildBarActiveNotifer: buildBarActiveNotifer, selectedPotNotifier: _selectedPotNotifier, id: id);
      case 'BROWN':       return Pot(item: itemSelected, buildBarActiveNotifer: buildBarActiveNotifer, selectedPotNotifier: _selectedPotNotifier, id: id);
      case 'GREEN':       return Pot(item: itemSelected, buildBarActiveNotifer: buildBarActiveNotifer, selectedPotNotifier: _selectedPotNotifier, id: id);
      case 'TURQUOISE':   return Pot(item: itemSelected, buildBarActiveNotifer: buildBarActiveNotifer, selectedPotNotifier: _selectedPotNotifier, id: id);
      case 'PINK':        return Pot(item: itemSelected, buildBarActiveNotifer: buildBarActiveNotifer, selectedPotNotifier: _selectedPotNotifier, id: id);
      case 'PURPLE':      return Pot(item: itemSelected, buildBarActiveNotifer: buildBarActiveNotifer, selectedPotNotifier: _selectedPotNotifier, id: id);
      case 'YELLOW':      return Pot(item: itemSelected, buildBarActiveNotifer: buildBarActiveNotifer, selectedPotNotifier: _selectedPotNotifier, id: id);
      default:            return Pot(item: itemSelected, buildBarActiveNotifer: buildBarActiveNotifer, selectedPotNotifier: _selectedPotNotifier, id: id);
    }
  }

  Future<void> _fetchPots() async {
    if(loggedInUserId == null) return;
    try{
      final response = await http.get(
        Uri.parse('$_baseUrl/home/userpots/$loggedInUserId'),
        headers: {
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        }
      );
      if(response.statusCode == 200 && mounted){
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _pots = data
            .cast<Map<String, dynamic>>()
            .map(_buildPot)
            .whereType<Pot>()
            .toList();

          _rebuildBuildBar();
        });
      }
    } catch(e){
      print('Error fetching pots: $e');
    }
  }

  Future<void> _loadGreenhouse() async {
    if (_greenhouseLoaded || loggedInUserId == null || !mounted) return;
    try {
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/home/greenhouse/$loggedInUserId'),
        headers: {if (authToken != null) 'Authorization': 'Bearer $authToken'},
      );
      if (response.statusCode == 200 && mounted) {
        final List<dynamic> data = jsonDecode(response.body);
        for (final item in data) {
          final int placementId = (item['placementId'] as num).toInt();
          final int? potId = (item['potId'] as num?)?.toInt();
          if(potId != null){
            _placedPotIds.add(potId);
            _slotPotIds[placementId] = potId;
          }
          final int? flowerId = (item['flowerId'] as num?)?.toInt();
          Flower? flower;
          if (flowerId != null) {
            final matches = flowerCollection.where((f) => f.id == flowerId);
            flower = matches.isNotEmpty ? matches.first : null;
            if (flower != null) {
              _placedFlowerIds.add(flowerId);
              _slotFlowerIds[placementId] = flowerId;
            }
          }
          _slotPotTemplates[placementId] = (item['template'] as String?) ?? 'BLUE';
          WidgetsBinding.instance.addPostFrameCallback((_) {
            addButtonKeys[placementId]?.currentState?.loadPot(
              item: itemSelected,
              buildBarActiveNotifer: buildBarActiveNotifer,
              selectedPotNotifier: _selectedPotNotifier,
              initialFlower: flower,
            );
          });
        }
        _greenhouseLoaded = true;
        setState(() {
          _rebuildBuildBar();
        });
      }
    } catch (e) {
      print('Error loading greenhouse: $e');
    }
  }

  Future<void> _saveGreenhouse() async {
    if (loggedInUserId == null) return;
    final List<Map<String, dynamic>> placements = [];
    for (final entry in _slotPotTemplates.entries) {
      placements.add({
        'placementId': entry.key,
        'potTemplate': entry.value,
        'potId': _slotPotIds[entry.key],
        'flowerId': _slotFlowerIds[entry.key],
      });
    }
    try {
      await _httpClient.post(
        Uri.parse('$_baseUrl/home/greenhouse/$loggedInUserId'),
        headers: {
          'Content-Type': 'application/json',
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(placements),
      );
    } catch (e) {
      print('Error saving greenhouse: $e');
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

  void loadPotsOnAddButtonWithIndex(List<int> indexs) {
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
      login_popup(context, onSuccess: () async {
        await fetchFlowers();
        await _fetchPots();
      });
    });
    // Your branch: also refresh when build mode opens
    buildModeActiveNotifier.addListener(() {
      if (buildModeActiveNotifier.value){
        fetchFlowers();
        _fetchPots();
      } 
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
        index: i,
        onPotPlaced: (idx) {
          final pot = itemSelected.value;

          if(pot is Pot && pot.id != null){
            _placedPotIds.add(pot.id!);
            _slotPotIds[idx] = pot.id;
          }
          _slotPotTemplates[idx] = 'BLUE';
          _slotFlowerIds[idx] = null;
          _saveGreenhouse();

          setState(() {
            _rebuildBuildBar();
          });
        },
        onFlowerPlanted: (idx, flower) {
          if (!mounted) return;
          final int? oldFlowerId = _slotFlowerIds[idx];
          if (oldFlowerId != null) {
            _placedFlowerIds.remove(oldFlowerId);
          }
          if (flower.id != null) {
            _placedFlowerIds.add(flower.id!);
          }
          _slotFlowerIds[idx] = flower.id;
          _saveGreenhouse();
          setState(() {
            _rebuildBuildBar();
          });
        },
      );
    });

    return buttons;
  }
}
//test