import 'package:flutter/material.dart';

class AddButton extends StatefulWidget {
  AddButton({super.key, required this.isVisible});
  final String imagePath = "lib/resources/images/add_button.png";

  bool isVisible;
  bool isTaken=false;

  @override
  AddButtonState createState() => AddButtonState();
}

class AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.1,
      child: Stack(
        children: [
          Visibility(
            visible: (widget.isVisible && !widget.isTaken),
            child: IconButton(
              onPressed: () {setState(() {
                widget.isTaken=true;
                print(widget.isTaken);
                print(widget.isVisible);
              });},
              icon: Image.asset(widget.imagePath),
            ),
          ),


        ],
      ),
    );
  }
}
