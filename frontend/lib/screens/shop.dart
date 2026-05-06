import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_demo/widgets/back_btn.dart';
import 'package:flutter_demo/widgets/coins.dart';
import '../resources/constants.dart';
import 'package:flutter_demo/items/buyable_item_creator.dart';
import 'package:flutter_demo/states/coins_state.dart';
import 'package:google_fonts/google_fonts.dart';

const String brownPotPath = "lib/resources/images/BrownPot.svg"; 
const String coinsPath = "lib/resources/images/coin_icon.png";
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
          title: Text('Shop', style: TextStyles.header),
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
              child: Padding(
                padding: const EdgeInsets.all(12), 
                child: Column(
                  children: [
                    Expanded(
                        child: SvgPicture.asset(item.image, fit: BoxFit.contain),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, 
                      children: [
                        Text(item.cost.toString(), style: const TextStyle(fontSize: 16)), 
                        const SizedBox(width: 4), 
                        Image.asset(coinsPath, height: 16, width: 16, fit: BoxFit.contain,), 
                      ]
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if(item.cost <= coinsState.getCoinValue()){
                          setState((){ 
                            coinsState.decreaseCoinValue(item.cost); 
                        });
                      }
                      },
                      child: Text("Buy item", style: TextStyles.body),
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

