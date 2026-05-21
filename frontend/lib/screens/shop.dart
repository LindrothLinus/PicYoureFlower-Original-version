import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/screens/flower_collection.dart';
import 'package:flutter_demo/states/check_button_overlay.dart';
import 'package:flutter_demo/widgets/back_btn.dart';
import 'package:flutter_demo/widgets/coins.dart';
import '../resources/constants.dart';
import 'package:flutter_demo/items/buyable_item_creator.dart';
import 'package:flutter_demo/states/coins_state.dart';
import 'package:flutter_demo/widgets/nav_bar.dart';
import 'package:http/http.dart' as http;

const String _baseUrl = 'https://group-1-75.pvt.dsv.su.se';

const String brownPotPath = "lib/resources/images/brown.webp";
//const String bluePotPath = "lib/resources/images/blue.webp";
const String bluePotPath = "lib/resources/images/BluePot_smaller.png";
const String greenPotPath = "lib/resources/images/green.webp";
const String mintPotPath = "lib/resources/images/mint.webp";
const String pinkPotPath = "lib/resources/images/pink.webp";
const String purplePotPath = "lib/resources/images/purple.webp";
const String yellowPotPath = "lib/resources/images/yellow.webp";
const String addPath = "lib/resources/images/Add.webp";

const String coinsPath = "lib/resources/images/coin.webp";
//Alla items
var buyableItems = [
  //BuyableItemCreator(cost: 5, image: brownPotPath),
  /*BuyableItemCreator(cost: 5, image: bluePotPath),
  BuyableItemCreator(cost: 5, image: greenPotPath),
  BuyableItemCreator(cost: 5, image: mintPotPath),
  BuyableItemCreator(cost: 5, image: pinkPotPath),
  BuyableItemCreator(cost: 5, image: purplePotPath),
  BuyableItemCreator(cost: 5, image: yellowPotPath),*/
];

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _Shop();
}

class _Shop extends State<Shop> {

  final CoinsState coinsState = CoinsState();

  //INIT CODE

  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){
      _fetchPots();
    });
  }

  //FETCH POTS CODE

  BuyableItemCreator _buildPot(Map<String, dynamic> data) {
    print("Inside buildPot");
    return BuyableItemCreator(cost: 5, image: mintPotPath);
    /*final String color = (data['template'] as String);
    switch(color){
      case 'BLUE':        return BuyableItemCreator(cost: 5, image: bluePotPath);
      case 'BROWN':       return BuyableItemCreator(cost: 5, image: brownPotPath);
      case 'GREEN':       return BuyableItemCreator(cost: 5, image: greenPotPath);
      case 'TURQUOISE':   return BuyableItemCreator(cost: 5, image: mintPotPath);
      case 'PINK':        return BuyableItemCreator(cost: 5, image: pinkPotPath);
      case 'PURPLE':      return BuyableItemCreator(cost: 5, image: purplePotPath);
      case 'YELLOW':      return BuyableItemCreator(cost: 5, image: yellowPotPath);
      default:            return BuyableItemCreator(cost: 5, image: brownPotPath);
    }*/
  }

  Future<void> _fetchPots() async {
    print("Before try catch in fetchPots");
    try{

      print("Before response pull");
      final response = await http.get(
        Uri.parse('$_baseUrl/home/allpots'), 
      );
      print("Before response statusCode");
      print(response.statusCode);
      if(response.statusCode == 200){
        print("Successful database load"); 
        
        final List<dynamic> data = jsonDecode(response.body);
        print(response.body);
        print(data.runtimeType);
        //This far is okay, 
        setState(() {
          print("inside setState");
          //buildpot is not called, wrong type is being passed to argument
          buyableItems = data.cast<Map<String, dynamic>>().map(_buildPot).toList();
        });
      }

    } catch (e){
      print("Error");
      //
    }
    
  }
  //FETCH POTS CODE

  @override
  Widget build(BuildContext context) {
    //buyableItems.add(BuyableItemCreator(cost: 5, image: brownPotPath));
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop', style: TextStyles.header),
        backgroundColor: backgroundColor,
        leading: CustomBackButton(toHome: true),
        actions: [Coins(coinsState: coinsState)],
      ),
      backgroundColor: backgroundColor,
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        itemCount: buyableItems.length,
        itemBuilder: (BuildContext context, int index) {
          final item = buyableItems[index];
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(item.cost.toString(), style: TextStyles.body),

                            const SizedBox(width: 4),
                            Image.asset(
                              coinsPath,
                              height: 20,
                              width: 20,
                              //fit: BoxFit.contain,
                            ),
                          ],
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            if (coinsState.getCoinValue() >= item.cost) {
                              coinsState.decreaseCoinValue(item.cost);
                              CheckButtonPopUp.showCheckButton(context);
                            }
                          },
                          icon: Image.asset(
                            addPath,
                            height: 20,
                            width: 20,
                            //fit: BoxFit.contain,
                          ),
                        ),
                      ],
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