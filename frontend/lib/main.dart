import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/add_button.dart';
import 'package:flutter_demo/widgets/build_bar.dart';
import 'package:flutter_demo/screens/Greenhouse.dart';
import 'package:flutter_demo/widgets/flowers/flower.dart';
import 'package:flutter_demo/widgets/flowers/rose_flower.dart';
import 'package:flutter_demo/widgets/nav_bar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/widgets/pots/blue_pot.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  final String title = "pic youre flower";

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final List<Flower> flowers = [
      RoseFlower(color: Colors.red),
      RoseFlower(color: Colors.blue),
      RoseFlower(color: Colors.pink),
      RoseFlower(color: Colors.orange),
      RoseFlower(color: Colors.green),
      RoseFlower(color: Colors.deepPurpleAccent),
    ];


  final buildModeActiveNotifier = ValueNotifier<bool>(false);
  late BuildBar buildBar;

  final itemSelected = ValueNotifier<Widget?>(null);
  @override
  void initState() {
    List<Pot> pots=[Pot(item:itemSelected),];

    super.initState();
    buildBar = BuildBar(
      flowers: flowers,
      pots: pots,
      visibilityNotifier: buildModeActiveNotifier,
      onFlowerSelected: (flower){
        if(flower != itemSelected.value){
          itemSelected.value=flower;
        }
        else{
          itemSelected.value=null;
        }
        print(itemSelected.value);

      },
      onPotSelected: (pot){
        if(itemSelected.value!=pot){
          itemSelected.value = pot;
        }
        else{
          itemSelected.value = null;
        }
        print(itemSelected.value);
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    List<AddButton> addButtons = [AddButton(builModeActiveNotifier: buildModeActiveNotifier, x: 3000, y: 1550,item: itemSelected,), AddButton(builModeActiveNotifier: buildModeActiveNotifier, x: 2500, y: 1550, item: itemSelected)];

    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Scaffold(
        body: Greenhouse(addButtons: addButtons,),
        bottomSheet: buildBar
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
