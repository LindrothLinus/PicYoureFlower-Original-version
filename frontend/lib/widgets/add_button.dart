import 'package:flutter/material.dart';
import 'package:flutter_demo/resources/constants.dart';

class AddButton extends StatefulWidget {
  AddButton({super.key, required this.builModeActiveNotifier, required this.x, required this.y});
  final String imagePath = "lib/resources/images/add_button.png";
  final double x;
  final double y;
  final ValueNotifier<bool> builModeActiveNotifier;
  bool isTaken=false;

  @override
  AddButtonState createState() => AddButtonState();
}

class AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: widget.builModeActiveNotifier, builder: (context,buildModeIsActviated,child){
      return Positioned(

        left: widget.x,
        top: widget.y,
        child:SizedBox(
      width: addButtonSize,
      height: addButtonSize,
      child: Stack(
        children: [
          Visibility(
            visible: (buildModeIsActviated && !widget.isTaken),
            child: GestureDetector(
              onTap: () {setState(() {
                widget.isTaken=true;
              });},
              child: Image.asset(widget.imagePath,width: addButtonSize,height: addButtonSize,),
                          
            ),
          ),


        ],
      ),
    )
    );
    });
    
    
  }
}
