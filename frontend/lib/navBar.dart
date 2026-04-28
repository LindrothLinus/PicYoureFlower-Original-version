import 'package:flutter/material.dart';
import 'resources/constants.dart';

class NavBar extends StatelessWidget{
  NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: BottomAppBar(
        color: MAIN_COLOR,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [     
            IconButton( icon: Image.asset("lib/resources/images/cart_icon.png"), onPressed: (){},),
            IconButton( icon: Image.asset("lib/resources/images/showel_icon.png"), onPressed: (){},),
            IconButton( icon: Image.asset("lib/resources/images/camera_icon.png"), onPressed: (){},),
            IconButton( icon: Image.asset("lib/resources/images/flower_icon.png"), onPressed: (){},),
            
            
        
          ],
        ),
        
      ));
  }
}