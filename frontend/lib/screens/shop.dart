import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_demo/widgets/back_btn.dart';
import 'package:flutter_demo/widgets/coins.dart';
import '../resources/constants.dart';
import 'package:flutter_demo/items/buyable_item_creator.dart';
import 'package:flutter_demo/states/coins_state.dart';

const String buildmodeIconPath = "lib/resources/images/showel_icon.png"; //tills vi har riktiga ikoner
const String bluePotPath = "lib/resources/images/BluePot.svg"; 
const String pinkPotPath = "lib/resources/images/pinkpot.svg"; 
const String brownPotPath = "lib/resources/images/BrownPot.svg"; 
//Alla items 
final buyableItems = [BuyableItemCreator(cost: 5, image: brownPotPath),];

class Shop extends StatefulWidget {
  const Shop({super.key});
  
  @override
  State<Shop> createState() => _ShopState(); 
  // Shop(this.coinsState);

} 

class _ShopState extends State<Shop>{
  final CoinsState coinsState = CoinsState(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Shop'),
          backgroundColor: mainColor,
          leading: CustomBackButton(),
          actions: [
            Coins(coinsState: coinsState),
          ]
        ),
        backgroundColor: mainColor,
        body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
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
                    AspectRatio(
                      aspectRatio: 1.4,
                      child: SvgPicture.asset(item.image, width: 48, height: 48),
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

