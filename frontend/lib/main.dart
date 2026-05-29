import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/screens/Greenhouse.dart';
import 'package:flutter_demo/screens/flower_info.dart';
import 'package:flutter_demo/widgets/add_button.dart';
import 'package:flutter_demo/widgets/build_bar.dart';
import 'package:flutter_demo/widgets/camera_button.dart';
import 'package:flutter_demo/widgets/flowers/flower.dart';
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
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.httpClient});

  //!För mockramverk annars ska denna vara lämnas null
  final http.Client? httpClient;
  final String title = "PicYourFlowers";

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
  List<Map<String, dynamic>> _flowerDataCollection = [];

  List<String> _ownedPotTemplates = ['BLUE'];

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


  void _rebuildBuildBar() {
    buildBar = BuildBar(
      flowers: flowerCollection
          .where((f) => f.id == null || !_placedFlowerIds.contains(f.id))
          .toList(),
      pots: _ownedPotTemplates
          .map((t) => Pot(
                item: itemSelected,
                buildBarActiveNotifer: buildBarActiveNotifer,
                selectedPotNotifier: _selectedPotNotifier,
                potTemplate: t,
              ))
          .toList(),
      visibilityNotifier: buildBarActiveNotifer,
      onFlowerSelected: (flower) {
        itemSelected.value = itemSelected.value != flower ? flower : null;
      },
      onPotSelected: (pot) {
        itemSelected.value = itemSelected.value != pot ? pot : null;
      },
    );
  }

  void _navigateToFlowerInfo(Flower flower) {
    final matches = _flowerDataCollection.where(
      (d) => (d['id'] as num?)?.toInt() == flower.id,
    );
    final data = matches.isNotEmpty ? matches.first : null;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlowerInfoScreen(
          flowerItem: flower,
          data: data,
        ),
      ),
    );
  }

  // Your branch: fetch the logged-in user's flowers from the backend
  @visibleForTesting
  Future<void> fetchFlowers() async {
    if (loggedInUserId == null) return;
    await fetchOwnedPots();
    try {
      final response = await _httpClient.get(
        Uri.parse('$flowerServiceUrl/home/user/$loggedInUserId/flowers'),
        headers: {if (authToken != null) 'Authorization': 'Bearer $authToken'},
      );
      if (response.statusCode == 200 && mounted) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _flowerDataCollection = data.cast<Map<String, dynamic>>();
          flowerCollection = _flowerDataCollection
              .map(Flower.buildFlower)
              .toList();
          _rebuildBuildBar();
        });
        await _loadGreenhouse();
      }
    } catch (e) {
      print('Error fetching flowers: $e');
    }
  }

  @visibleForTesting
  Future<void> fetchOwnedPots() async {
    if (loggedInUserId == null) return;
    try {
      final response = await _httpClient.get(
        Uri.parse('$userServiceUrl/home/ownedpottemplates/$loggedInUserId'),
        headers: {if (authToken != null) 'Authorization': 'Bearer $authToken'},
      );
      if (response.statusCode == 200 && mounted) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _ownedPotTemplates = data.cast<String>();
          _rebuildBuildBar();
        });
      }
    } catch (e) {
      print('Error fetching owned pots: $e');
    }
  }

  Future<void> _loadGreenhouse() async {
    if (_greenhouseLoaded || loggedInUserId == null || !mounted) return;
    try {
      final response = await _httpClient.get(
        Uri.parse('$userServiceUrl/home/greenhouse/$loggedInUserId'),
        headers: {if (authToken != null) 'Authorization': 'Bearer $authToken'},
      );
      if (response.statusCode == 200 && mounted) {
        final List<dynamic> data = jsonDecode(response.body);
        for (final item in data) {
          final int placementId = (item['placementId'] as num).toInt();
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
              potTemplate: (item['template'] as String?) ?? 'BLUE',
              buildModeActiveNotifier: buildModeActiveNotifier,
              onFlowerInfoRequested: _navigateToFlowerInfo,
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
        'flowerId': _slotFlowerIds[entry.key],
      });
    }
    try {
      await _httpClient.post(
        Uri.parse('$userServiceUrl/home/greenhouse/$loggedInUserId'),
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
            Greenhouse(
              addButtons: _addButtons,
              buildModeActiveNotifier: buildModeActiveNotifier,
              buildBarActiveNotifer: buildBarActiveNotifer,
              onBuildModeButtonPressed: () {
                buildModeActiveNotifier.value = !buildModeActiveNotifier.value;
                //buildBarActiveNotifer.value = !buildBarActiveNotifer.value;
                print(extractPots());
              },
              ),
            SafeArea(child: FriendMenu(addButtonsCordinates: _addButtoncordinates,userId: loggedInUserId,)),
          ],
        ),
        bottomSheet: buildBar,
      ),
      bottomNavigationBar: NavBar(
        onBuildModeButtonPressed: () {
          buildModeActiveNotifier.value = false;
          buildBarActiveNotifer.value = false;
          print(extractPots());
        },
      ),
    );

  }

  void loadPotsOnAddButtonWithIndex(List<int> indexs) {
    for (int i in indexs) {
      addButtonKeys[i]?.currentState?.setPot(
        Pot(
          item: itemSelected,
          buildBarActiveNotifer: buildBarActiveNotifer,
          selectedPotNotifier: _selectedPotNotifier,
          buildModeActiveNotifier: buildModeActiveNotifier,
          onFlowerInfoRequested: _navigateToFlowerInfo,
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
    _pots = _ownedPotTemplates
        .map((t) => Pot(
              item: itemSelected,
              buildBarActiveNotifer: buildBarActiveNotifer,
              selectedPotNotifier: _selectedPotNotifier,
              potTemplate: t,
            ))
        .toList();
    // Your branch: pass onSuccess so flowers load right after login
    WidgetsBinding.instance.addPostFrameCallback((_) {
      login_popup(context, onSuccess: fetchFlowers);
    });
    // Your branch: also refresh when build mode opens
    buildModeActiveNotifier.addListener(() {
      if (buildModeActiveNotifier.value) fetchFlowers();
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
        buildModeActiveNotifier: buildModeActiveNotifier,
        onFlowerInfoRequested: _navigateToFlowerInfo,
        x: cordinates[i].x,
        y: cordinates[i].y,
        item: itemSelected,
        index: i,
        onPotPlaced: (idx, template) {
          final int? oldFlowerId = _slotFlowerIds[idx];
          if (oldFlowerId != null) {
            _placedFlowerIds.remove(oldFlowerId);
          }
          _slotPotTemplates[idx] = template;
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