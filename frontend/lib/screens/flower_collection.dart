import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/back_btn.dart';
import 'package:flutter_demo/widgets/flowers/genericflower.dart';
import 'package:flutter_demo/widgets/flowers/rose_flower.dart';
import 'package:flutter_demo/widgets/flowers/sunflower.dart';
import 'package:flutter_demo/widgets/flowers/tulip.dart';
import 'package:flutter_demo/widgets/flowers/woodanemone.dart';
import 'package:flutter_demo/widgets/nav_bar.dart';
import '../resources/constants.dart';

//Blommorna, dess färg och namn måste hämtas från databasen
final flowerCollection = [
  RoseFlower(color: Colors.red, name: "Rose"),
  SunFlower(color: Colors.yellow, name: "Sunflowerhkjhkjhjhjkhk"),
  GenericFlower(color: Colors.blueAccent, name: "Flower"),
  TulipFlower(color: Colors.pinkAccent, name: "Tulip"),
  WoodanemoneFlower(color: Colors.white, name: "Wood anemone"),
  RoseFlower(color: Colors.redAccent, name: "Rose"),
];

class FlowerCollection extends StatelessWidget {
  const FlowerCollection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My flowers', style: TextStyles.header),
        backgroundColor: backgroundColor,
        leading: CustomBackButton(),
      ),
      backgroundColor: backgroundColor,
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: flowerCollection.length,
        itemBuilder: (BuildContext context, int index) {
          final item = flowerCollection[index];
          return Card(
            elevation: 5,
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: SizedBox(
                      height: 90,
                      child: Image.asset(
                        item.backGround,
                        color: item.color,
                        height: 90,
                        width: 90,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: SizedBox(
                      height: 90,
                      child: Image.asset(
                        item.frontImage,
                        height: 90,
                        width: 90,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: 30,
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
                        Expanded(
                          child: Text(
                            item.name,
                            style: TextStyles.infoText,
                            overflow: TextOverflow.ellipsis,
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
