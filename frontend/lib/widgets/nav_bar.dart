import 'package:flutter/material.dart';
import 'package:flutter_demo/screens/camera.dart';
import 'package:flutter_demo/screens/flower_collection.dart';
import '../resources/constants.dart';
import '../screens/shop.dart';

const String shopIconPath = "lib/resources/images/cart_icon.png";
const String buildmodeIconPath = "lib/resources/images/showel_icon.png";
const String cameraIconPath = "lib/resources/images/camera_icon.png";
const String flowerCollectionIconPath = "lib/resources/images/flower_icon.png";


class NavBar extends StatelessWidget{
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        color: mainColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [     
            IconButton( icon: Image.asset(shopIconPath), onPressed: (){Navigator.push(context, MaterialPageRoute<void>(builder: (context)=>const Shop()));},),
            IconButton( icon: Image.asset(buildmodeIconPath), onPressed: (){},),
            IconButton( icon: Image.asset(cameraIconPath), onPressed: (){Navigator.push(context, MaterialPageRoute<void>(builder: (context)=>const Camera()));},),
            IconButton( icon: Image.asset(flowerCollectionIconPath), onPressed: (){Navigator.push(context, MaterialPageRoute<void>(builder: (context)=>FlowerCollection()));},),
        
          ],
        ),
        
      );
  }
}