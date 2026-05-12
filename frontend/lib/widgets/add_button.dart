import 'package:flutter/material.dart';

class AddButton extends StatefulWidget {
  AddButton({super.key, required this.builModeActiveNotifier});
  final String imagePath = "lib/resources/images/add_button.png";

  final ValueNotifier<bool> builModeActiveNotifier;
  bool isTaken=false;

  @override
  AddButtonState createState() => AddButtonState();
}

class AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: widget.builModeActiveNotifier, builder: (context,buildModeIsActviated,child){
      return FractionallySizedBox(
      widthFactor: 0.1,
      child: Stack(
        children: [
          Visibility(
            visible: (buildModeIsActviated && !widget.isTaken),
            child: IconButton(
              onPressed: () {setState(() {
                widget.isTaken=true;
              });},
              icon: Image.asset(widget.imagePath),
            ),
          ),


        ],
      ),
    );
    });
    
    
  }
}
