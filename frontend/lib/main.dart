import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/screens/Greenhouse.dart';
import 'package:flutter_demo/widgets/add_button.dart';
import 'package:flutter_demo/widgets/build_bar.dart';
import 'package:flutter_demo/widgets/flowers/flower.dart';
import 'package:flutter_demo/widgets/flowers/genericflower.dart';
import 'package:flutter_demo/widgets/flowers/rose_flower.dart';
import 'package:flutter_demo/widgets/flowers/sunflower.dart';
import 'package:flutter_demo/widgets/flowers/tulip.dart';
import 'package:flutter_demo/widgets/flowers/woodanemone.dart';
import 'package:flutter_demo/widgets/friend_menu.dart';
import 'package:flutter_demo/widgets/login_popup.dart';
import 'package:flutter_demo/widgets/nav_bar.dart';
import 'package:flutter_demo/widgets/pots/blue_pot.dart';

import '../resources/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  final String title = "PicYourFlower";

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final List<Flower> flowers = [
      RoseFlower(color: Colors.red, name: "k",),
      GenericFlower(color: Colors.lightBlue, name: "o"),
      SunFlower(color: Colors.yellowAccent, name: ""),
      TulipFlower(color: Colors.purpleAccent, name: "name"),
      WoodanemoneFlower(color: Colors.green, name: "")

    ];


  final buildModeActiveNotifier = ValueNotifier<bool>(false);
  late BuildBar buildBar;

  final itemSelected = ValueNotifier<Widget?>(null);
  @override 
  void initState() {
    List<Pot> pots=[Pot(item:itemSelected),];

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      login_popup(context);
    });

    buildBar = BuildBar(
      flowers: flowers,
      pots: pots,
      visibilityNotifier: buildModeActiveNotifier,
      onFlowerSelected: (flower) {
        if (flower != itemSelected.value) {
          itemSelected.value = flower;
        } else {
          itemSelected.value = null;
        }
        print(itemSelected.value);
      },
      onPotSelected: (pot) {
        if (itemSelected.value != pot) {
          itemSelected.value = pot;
        } else {
          itemSelected.value = null;
        }
        print(itemSelected.value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<AddButton> addButtons = [
      AddButton(
        builModeActiveNotifier: buildModeActiveNotifier,
        x: 3000,
        y: 1400,
        item: itemSelected,
      ),
      AddButton(
        builModeActiveNotifier: buildModeActiveNotifier,
        x: 2500,
        y: 1400,
        item: itemSelected,
      ),
      AddButton(
        builModeActiveNotifier: buildModeActiveNotifier,
        x: 3000,
        y: 2150,
        item: itemSelected,
      ),
      AddButton(
        builModeActiveNotifier: buildModeActiveNotifier,
        x: 2500,
        y: 2150,
        item: itemSelected,
      ),
      AddButton(
        builModeActiveNotifier: buildModeActiveNotifier,
        x: 3000,
        y: 2850,
        item: itemSelected,
      ),
      AddButton(
        builModeActiveNotifier: buildModeActiveNotifier,
        x: 2500,
        y: 2850,
        item: itemSelected,
      ),
            AddButton(
        builModeActiveNotifier: buildModeActiveNotifier,
        x: 2000,
        y: 2850,
        item: itemSelected,
      ),
      AddButton(
        builModeActiveNotifier: buildModeActiveNotifier,
        x: 3500,
        y: 2850,
        item: itemSelected,
      ),

            AddButton(
        builModeActiveNotifier: buildModeActiveNotifier,
        x: 4000,
        y: 2850,
        item: itemSelected,
      ),
      AddButton(
        builModeActiveNotifier: buildModeActiveNotifier,
        x: 1500,
        y: 2850,
        item: itemSelected,
      ),
      
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title, style: TextStyles.header),
      ),
      body: Scaffold(
        body: Stack(
          children: [
            Greenhouse(addButtons: addButtons),
            SafeArea(child: FriendMenu())
          ],
        ),
        
        bottomSheet: buildBar,
      ),

      bottomNavigationBar: NavBar(
        onBuildModeButtonPressed: () {
          buildModeActiveNotifier.value = !buildModeActiveNotifier.value;
        },
      ),
    );

    //test du kan ta bort denna komentar
  }
}
//test