import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/items/buyable_item_creator.dart';
import 'package:flutter_demo/states/check_button_overlay.dart';
import 'package:flutter_demo/states/coins_state.dart';
import 'package:flutter_demo/widgets/back_btn.dart';
import 'package:flutter_demo/widgets/camera_button.dart';
import 'package:flutter_demo/widgets/coins.dart';
import 'package:flutter_demo/widgets/nav_bar.dart';
import 'package:http/http.dart' as http;

import '../resources/constants.dart';

//const String _baseUrl = 'https://group-1-75.pvt.dsv.su.se';
const String _baseUrl = 'http://10.0.2.2:8080';

const String brownPotPath = "lib/resources/images/brown_smaller.png";
const String bluePotPath = "lib/resources/images/BluePot_smaller.png";
const String greenPotPath = "lib/resources/images/green_smaller.png";
const String mintPotPath = "lib/resources/images/mint_smaller.png";
const String pinkPotPath = "lib/resources/images/pink_smaller.png";
const String purplePotPath = "lib/resources/images/purple_smaller.png";
const String yellowPotPath = "lib/resources/images/yellow_smaller.png";
const String addPath = "lib/resources/images/add_smaller.PNG";

const String coinsPath = "lib/resources/images/coin.webp";

//Alla items
const List<Map<String, dynamic>> _allPotConfigs = [
  {'color': 'BLUE', 'image': bluePotPath, 'cost': 5},
  {'color': 'BROWN', 'image': brownPotPath, 'cost': 5},
  {'color': 'GREEN', 'image': greenPotPath, 'cost': 5},
  {'color': 'TURQUOISE', 'image': mintPotPath, 'cost': 5},
  {'color': 'PINK', 'image': pinkPotPath, 'cost': 5},
  {'color': 'PURPLE', 'image': purplePotPath, 'cost': 5},
  {'color': 'YELLOW', 'image': yellowPotPath, 'cost': 5},
];

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _Shop();
}

class _Shop extends State<Shop> {
  final CoinsState coinsState = CoinsState();
  List<BuyableItemCreator> _buyableItems = [];
  Set<String> _ownedTemplates = {};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPots();
    });
  }

  //FETCH POTS CODE

  Future<void> _fetchPots() async {
    if (loggedInUserId == null) return;
    try {
      final response = await http.get(
        Uri.parse('$userServiceUrl/home/ownedpottemplates/$loggedInUserId'),
      );
      if (response.statusCode == 200 && mounted) {
        final List<dynamic> owned = jsonDecode(response.body);
        setState(() {
          _ownedTemplates = owned.map((e) => e.toString()).toSet();
          _buyableItems = _allPotConfigs
              .where((c) => !_ownedTemplates.contains(c['color']))
              .map(
                (c) => BuyableItemCreator(
                  cost: c['cost'] as int,
                  image: c['image'] as String,
                  color: c['color'] as String,
                ),
              )
              .toList();
        });
      }
    } catch (e) {
      print("Error fetching pots: $e");
    }
  }

  //FETCH POTS CODE

  Future<void> sendPot(String potColor) async {
    try {
      final response = await http.put(
        Uri.parse('$userServiceUrl/home/addpot/$loggedInUserId/$potColor'),
      );
      if (response.statusCode == 200 && mounted) {
        await _fetchPots();
      }
    } catch (e) {
      print('Error with sending pots: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop', style: TextStyles.header),
        backgroundColor: backgroundColor,
        leading: CustomBackButton(toHome: true),
        actions: [Coins(coinsState: coinsState)],
      ),
      backgroundColor: backgroundColor,
      body: _buyableItems.isEmpty
          ? Center(
              child: Text(
                'You own all available pots!',
                style: TextStyles.infoText,
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: _buyableItems.length,
              itemBuilder: (BuildContext context, int index) {
                final item = _buyableItems[index];
                return Card(
                  elevation: 5,
                  child: Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: SizedBox(
                            height: 75,
                            child: Image.asset(
                              item.image,
                              height: 65,
                              width: 65,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: purpleColor,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      item.cost.toString(),
                                      style: TextStyles.body,
                                    ),

                                    const SizedBox(width: 4),
                                    Image.asset(
                                      coinsPath,
                                      height: 30,
                                      width: 30,
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 6),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () async {
                                    if (coinsState.getCoinValue() >=
                                        item.cost) {
                                      int newValue =
                                          coinsState.getCoinValue() - item.cost
                                              as int;
                                      coinsState.setCoinValue(newValue);
                                      coinsState.updateCoinValue(newValue);
                                      sendPot(item.color);
                                      //CheckButtonPopUp.showCheckButton(context);
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return Center(
                                            child: SizedBox(
                                              width: 100,
                                              height: 100,
                                              child: Image.asset(
                                                'lib/resources/images/Confirmed.png',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                      await Future.delayed(
                                        const Duration(seconds: 1),
                                      );
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  icon: Image.asset(
                                    addPath,
                                    height: 30,
                                    width: 30,
                                    //fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: NavBar(onBuildModeButtonPressed: () {}),
    );
  }
}
