import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/add_button.dart';
import 'package:flutter_demo/widgets/build_bar.dart';
import 'package:flutter_demo/screens/Greenhouse.dart';
import 'package:flutter_demo/widgets/nav_bar.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  final String title = "pic youre flower";

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final buildModeActiveNotifier = ValueNotifier<bool>(false);
  late BuildBar buildBar;

  @override
  void initState() {
    super.initState();
    buildBar = BuildBar(
      visibilityNotifier: buildModeActiveNotifier,
      onFlowerSelected: (flower){print(flower);},
      onPotSelected: (pot){print(pot);},
    );
  }

  @override
  Widget build(BuildContext context) {
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
        body: Greenhouse(),
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
