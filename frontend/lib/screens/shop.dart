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

];

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _Shop();
}

class _Shop extends State<Shop> {

  final CoinsState coinsState = CoinsState();

  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){
      _fetchPots();
      
    });
  }

  //FETCH POTS CODE

  Future<void> _fetchPots() async {
    try{
      final response = await http.get(
        Uri.parse('$userServiceUrl/home/allpots'), 
      );
      if(response.statusCode == 200){
        
        final List<dynamic> data = jsonDecode(response.body); 
        setState(() {
          buyableItems.clear();
          for(dynamic potColor in data){
            switch(potColor){
              case 'BLUE':        buyableItems.add(BuyableItemCreator(cost: 5, image: bluePotPath, color: "BLUE")); break;
              case 'BROWN':       buyableItems.add(BuyableItemCreator(cost: 5, image: brownPotPath, color: "BROWN")); break;
              case 'GREEN':       buyableItems.add(BuyableItemCreator(cost: 5, image: greenPotPath, color: "GREEN")); break;
              case 'TURQUOISE':   buyableItems.add(BuyableItemCreator(cost: 5, image: mintPotPath, color: "TURQUOISE")); break;
              case 'PINK':        buyableItems.add(BuyableItemCreator(cost: 5, image: pinkPotPath, color: "PINK")); break;
              case 'PURPLE':      buyableItems.add(BuyableItemCreator(cost: 5, image: purplePotPath, color: "PURPLE")); break;
              case 'YELLOW':      buyableItems.add(BuyableItemCreator(cost: 5, image: yellowPotPath, color: "YELLOW")); break;
              default:            buyableItems.add(BuyableItemCreator(cost: 5, image: brownPotPath, color: "BROWN")); break;
            }
          }
        });
      }

    } catch (e){
      print("Error");
    }
    
  }
  //FETCH POTS CODE

  Future<void> sendPot(String potColor) async{
    try{
      http.put(
        Uri.parse('$userServiceUrl/home/addpot/$loggedInUserId/$potColor')
      );
      
    } catch(e){
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
                              int newValue = coinsState.getCoinValue() - item.cost as int;
                              coinsState.setCoinValue(newValue);
                              coinsState.updateCoinValue(newValue);
                              sendPot(item.color);
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