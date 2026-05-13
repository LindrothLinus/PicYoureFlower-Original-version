import 'package:flutter/material.dart';
import 'package:flutter_demo/states/check_button_overlay.dart';
import 'package:flutter_demo/widgets/back_btn.dart';
import 'package:flutter_demo/widgets/coins.dart';
import '../resources/constants.dart';
import 'package:flutter_demo/items/buyable_item_creator.dart';
import 'package:flutter_demo/states/coins_state.dart';
import 'package:flutter_demo/widgets/nav_bar.dart';

const String brownPotPath = "lib/resources/images/brown.webp";
const String bluePotPath = "lib/resources/images/blue.webp";
const String greenPotPath = "lib/resources/images/green.webp";
const String mintPotPath = "lib/resources/images/mint.webp";
const String pinkPotPath = "lib/resources/images/pink.webp";
const String purplePotPath = "lib/resources/images/purple.webp";
const String yellowPotPath = "lib/resources/images/yellow.webp";
const String addPath = "lib/resources/images/Add.webp";

const String coinsPath = "lib/resources/images/coin.webp";
//Alla items
final buyableItems = [
  BuyableItemCreator(cost: 5, image: brownPotPath),
  BuyableItemCreator(cost: 5, image: bluePotPath),
  BuyableItemCreator(cost: 5, image: greenPotPath),
  BuyableItemCreator(cost: 5, image: mintPotPath),
  BuyableItemCreator(cost: 5, image: pinkPotPath),
  BuyableItemCreator(cost: 5, image: purplePotPath),
  BuyableItemCreator(cost: 5, image: yellowPotPath),
];

class Shop extends StatelessWidget {
  Shop({super.key});

  final CoinsState coinsState = CoinsState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop', style: TextStyles.header),
        backgroundColor: backgroundColor,
        leading: CustomBackButton(),
        actions: [Coins(coinsState: coinsState)],
      ),
      backgroundColor: backgroundColor,
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Text(item.cost.toString(), style: TextStyles.body),
                            const SizedBox(width: 4),
                            Image.asset(
                              coinsPath,
                              height: 30,
                              width: 30,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (coinsState.getCoinValue() >= item.cost) {
                                  coinsState.decreaseCoinValue(item.cost);
                                  CheckButtonPopUp.showCheckButton(context);
                                }
                              },
                              icon: Image.asset(
                                addPath,
                                height: 30,
                                width: 30,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
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
