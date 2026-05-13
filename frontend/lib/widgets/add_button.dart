import 'package:flutter/material.dart';
import 'package:flutter_demo/resources/constants.dart';

class AddButton extends StatefulWidget {
  AddButton({super.key, required this.builModeActiveNotifier, required this.x, required this.y, required this.item});
  final String imagePath = "lib/resources/images/add_button.png";
  final double x;
  final double y;
  final ValueNotifier<bool> builModeActiveNotifier;
  final ValueNotifier<Widget?> item;
  bool isTaken=false;

  @override
  AddButtonState createState() => AddButtonState();
}

class AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    Widget? newItem = widget.item.value;
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
            child:ValueListenableBuilder(valueListenable: widget.item, builder: (context,item,child){
              return GestureDetector(
              onTap: () {
                print(item);
                if(item != null){
                setState(() {
                widget.isTaken=true;
              });
                }
                },
              child: Image.asset(widget.imagePath,width: addButtonSize,height: addButtonSize,),
                          
            );
            }) 
            
          ),
          newItem??Container()

        ],
      ),
    )
    );
    });
    
    
  }
}
