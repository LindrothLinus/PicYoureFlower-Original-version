import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_demo/resources/constants.dart';

class BuildBar extends StatefulWidget{
  const BuildBar({super.key});

  @override
  BuildBarState createState() => BuildBarState();

}

class BuildBarState extends State<BuildBar>{


  @override
  Widget build(BuildContext context) {
    const String flowerText = "Youre Flowers:";
    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 0.5,

      child:MaterialApp(
        debugShowCheckedModeBanner: false,
        title: flowerText,
        home: Scaffold(
          backgroundColor: Colors.teal,
          appBar: AppBar(title:const Text(flowerText),backgroundColor: Colors.teal,),
          body: Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            height: 200,
            child:ScrollConfiguration(
              behavior: const MaterialScrollBehavior().copyWith(dragDevices:{...PointerDeviceKind.values}),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for(final Color color in Colors.primaries)
                    Container(width: 160,color: color,),
                  
                ],
              ))
          ),
        )
      )
      
      ,);
  }

}