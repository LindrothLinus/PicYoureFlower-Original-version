import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/nav_bar.dart';
import 'package:flutter_demo/widgets/back_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //runApp(const MyApp());
  runApp(
    const MaterialApp(
      home: SvgBackgroundScreen(),
    ),
  );
}

// All new code removed from the demo version

class SvgBackgroundScreen extends StatefulWidget {
  const SvgBackgroundScreen({super.key});

  @override
  State<SvgBackgroundScreen> createState() => _SvgBackgroundScreenState();
}

class _SvgBackgroundScreenState extends State<SvgBackgroundScreen> {
  
  final TransformationController controller = TransformationController();

  @override
  void initState(){
    super.initState();

    controller.value = Matrix4.translationValues(-200, -200, 0)
    ..multiply(Matrix4.diagonal3Values(2.0, 2.0, 1.0));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InteractiveViewer(
        constrained: true,
        boundaryMargin: EdgeInsets.zero,
        clipBehavior: Clip.hardEdge,
        minScale: 2,
        maxScale: 2,
        transformationController: controller,
        child: SizedBox(
          width: 4000,
          height: 4000,
          child: SvgPicture.asset(
            "lib/resources/images/Greenhouse.svg",
          )
        ),
      ),

      bottomNavigationBar: NavBar()
    );
  }

}

// End of all new code

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //Isak wanted to see if I can push to repo!
  //Ida wanted to see if I can push to repo!
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.amber),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),

      

      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          scaleEnabled: true,
          minScale: 0.5,
          maxScale: 5.0,
          child: SvgPicture.asset(
            "lib/resources/images/Greenhouse.svg",
            width: 2000,
            height: 2000,
          )
        )
      ),

      /*
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      */
  
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      
      bottomNavigationBar: NavBar(),
    );
  }
}

class MySvgWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "lib/resources/images/Greenhouse.svg",
      semanticsLabel: 'background',
      //width: 200,
      //height:200,
    );
  }
}


class BackGroundSvgWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    var padding =   MediaQuery.paddingOf(context);
    double newHeight = screenHeight - padding.top - padding.bottom;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              "lib/resources/images/Greenhouse.svg")
          ]
        )
      )
    );
    
    /*return SvgPicture.asset(
      "lib/resources/images/Greenhouse.svg", 
      semanticsLabel: 'background',
      
    );*/
  }
}
