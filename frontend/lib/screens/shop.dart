import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/back_btn.dart';
import 'package:flutter_demo/widgets/coins.dart';
import '../resources/constants.dart';
import 'package:flutter_demo/items/buyable_item_creator.dart';
import 'package:flutter_demo/states/coins_state.dart';
import 'package:flutter_demo/widgets/nav_bar.dart';

const String brownPotPath = "lib/resources/images/brownPot.png";
const String bluePotPath = "lib/resources/images/bluePot.png";
const String greenPotPath = "lib/resources/images/greenPot.png";
const String mintPotPath = "lib/resources/images/mintPot.png";
const String pinkPotPath = "lib/resources/images/pinkPot.png";
const String purplePotPath = "lib/resources/images/purplePot.png";
const String yellowPotPath = "lib/resources/images/yellowPot.png";

const String coinsPath = "lib/resources/images/coin_icon.png";
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

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
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
                      color: mainColor,
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

                        Image.asset(
                          coinsPath,
                          height: 30,
                          width: 30,
                          fit: BoxFit.contain,
                        ), //Det här ska vara plusset, och en knapp också som anropar decreaseValue
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
