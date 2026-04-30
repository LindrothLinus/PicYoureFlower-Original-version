import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/back_btn.dart';
import 'package:flutter_demo/widgets/coins.dart';
import '../resources/constants.dart';
import 'package:flutter_demo/items/buyable_item_creator.dart';

const String buildmodeIconPath = "lib/resources/images/showel_icon.png"; //tills vi har riktiga ikoner
//Alla items 
final buyableItems = [BuyableItemCreator(cost: 50, image: buildmodeIconPath), BuyableItemCreator(cost: 200, image: buildmodeIconPath), BuyableItemCreator(cost: 700, image: buildmodeIconPath), BuyableItemCreator(cost: 60, image: buildmodeIconPath), BuyableItemCreator(cost: 40, image: buildmodeIconPath), BuyableItemCreator(cost: 30, image: buildmodeIconPath), BuyableItemCreator(cost: 20, image: buildmodeIconPath)];

class Shop extends StatelessWidget {
  const Shop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Shop'),
          backgroundColor: mainColor,
          leading: CustomBackButton(),
          actions: [
            Coins(),
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
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(item.image, fit: BoxFit.contain,),
                  ),
                  Text(item.cost.toString() + " kr"), //Ska ändras sedan så det är kopplat till coin
                ],
              ),
            );
        },
      ),
    );
  }
}