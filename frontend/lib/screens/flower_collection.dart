import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/back_btn.dart';
import 'package:flutter_demo/widgets/flowers/rose_flower.dart';
import 'package:flutter_demo/widgets/nav_bar.dart';
import '../resources/constants.dart';

Color flowerColor = Colors.orange;
//Blommorna och dess färg måste hämtas från databasen
final flowerCollection = [
  RoseFlower(color: flowerColor),
  RoseFlower(color: flowerColor),
  RoseFlower(color: flowerColor),
  RoseFlower(color: flowerColor),
  RoseFlower(color: flowerColor),
  RoseFlower(color: flowerColor),
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
                      height: 75,
                      child: Image.asset(
                        item.frontImage,
                        height: 65,
                        width: 65,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: SizedBox(
                      height: 75,
                      child: Image.asset(
                        item.backGround,
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
                    /* decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ), */
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


//GAMLA koden
/* class FlowerCollection extends StatefulWidget {
  const FlowerCollection({super.key});

  @override
  State<FlowerCollection> createState() => FlowerCollectionState();
}

class FlowerCollectionState extends State<FlowerCollection> {
  //!Alt detta är debug kod som går att ta bort
  Color flowerColor = Colors.orange;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flower Collection'),
        backgroundColor: const Color.fromARGB(255, 221, 25, 11),
        leading: CustomBackButton(),
      ),

      body: RoseFlower(color: flowerColor),

      bottomNavigationBar: IconButton(
        onPressed: () {
          setState(() {
            changeColor();
          });
        },
        icon: Icon(Icons.abc),
      ),

      backgroundColor: const Color.fromARGB(255, 221, 99, 90),
    );
  }

  void changeColor() {
    if (flowerColor == Colors.green) {
      flowerColor = Colors.blue;
    } else {
      flowerColor = Colors.green;
    }
  }
}
 */