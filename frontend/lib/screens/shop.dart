import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_demo/widgets/back_btn.dart';
import 'package:flutter_demo/widgets/coins.dart';
import '../resources/constants.dart';
import 'package:flutter_demo/items/buyable_item_creator.dart';
import 'package:flutter_demo/states/coins_state.dart';

const String brownPotPath = "lib/resources/images/BrownPot.svg"; 
//Alla items 
final buyableItems = [BuyableItemCreator(cost: 5, image: brownPotPath), BuyableItemCreator(cost: 5, image: brownPotPath), BuyableItemCreator(cost: 5, image: brownPotPath), BuyableItemCreator(cost: 5, image: brownPotPath), BuyableItemCreator(cost: 5, image: brownPotPath), BuyableItemCreator(cost: 5, image: brownPotPath), BuyableItemCreator(cost: 5, image: brownPotPath), BuyableItemCreator(cost: 5, image: brownPotPath),];

class Shop extends StatefulWidget {
  const Shop({super.key});
  
  @override
  State<Shop> createState() => _ShopState(); 

} 

class _ShopState extends State<Shop>{
  final CoinsState coinsState = CoinsState(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Shop'),
          backgroundColor: backgroundColor,
          leading: CustomBackButton(),
          actions: [
            Coins(coinsState: coinsState),
          ]
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
        itemBuilder: (BuildContext context, int index){
          final item = buyableItems[index]; 
          return 
            Card(
              elevation: 5,
              color: blockColor,
              child: Padding(
                padding: const EdgeInsets.all(12), 
                child: Column(
                  children: [
                    Expanded(
                        child: SvgPicture.asset(item.image, fit: BoxFit.contain),
                    ),
                    Text(item.cost.toString() + " coins"), 
                    ElevatedButton(
                      onPressed: () {
                        if(item.cost <= coinsState.getCoinValue()){
                          setState((){ 
                            coinsState.decreaseCoinValue(item.cost); 
                        });
                      }
                      },
                      child: Text("Buy item"),
                    ),
                  ],
              ),
              ),
            );
        },
      ),
    );
  }
}

