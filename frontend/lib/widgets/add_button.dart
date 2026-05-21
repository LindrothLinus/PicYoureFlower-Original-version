import 'package:flutter/material.dart';
import 'package:flutter_demo/resources/constants.dart';
import 'package:flutter_demo/widgets/pots/blue_pot.dart';

class AddButton extends StatefulWidget {
  AddButton({
    super.key,
    required this.builModeActiveNotifier,
    required this.x,
    required this.y,
    required this.item,
    required this.buildBarActiveNotifer,
  });
  final String imagePath = "lib/resources/images/Add.webp";
  final double x;
  final double y;
  final ValueNotifier<bool> builModeActiveNotifier;
  final ValueNotifier<bool> buildBarActiveNotifer;
  final ValueNotifier<Widget?> item;
  bool checking=false;

  

  @override
  AddButtonState createState() => AddButtonState();
}

class AddButtonState extends State<AddButton> {
  bool isTaken = false;
  Widget? lockedItem;

  @override
  void initState() {
    super.initState();
    widget.item.addListener(
      (){
          if (widget.item.value != null && widget.checking && widget.item.value is Pot) {
                      setState(() {
                        isTaken = true;
                        lockedItem = widget.item.value;
                        widget.item.value = null;
                        widget.buildBarActiveNotifer.value = false;
                        widget.checking = false; 
                      });
            }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.builModeActiveNotifier,
      builder: (context, buildModeIsActviated, child) {
        return Positioned(
          left: widget.x,
          top: widget.y,
          child: SizedBox(
            width: addButtonSize,
            height: addButtonSize,
            child: ValueListenableBuilder(
              valueListenable: widget.item,
              builder: (context, item, child) {
                return GestureDetector(
                  onTap: () {
                    widget.checking=true;
                    widget.buildBarActiveNotifer.value=!widget.buildBarActiveNotifer.value;
                    /*if (item != null && !isTaken && item is Pot) {
                      setState(() {
                        isTaken = true;
                        lockedItem = item; // Lock the current value
                      });
                    }*/
                  },
                  child: isTaken
                      ? FittedBox(fit: BoxFit.contain, child: lockedItem)
                      : Visibility(
                          visible: buildModeIsActviated,
                          child: Image.asset(
                            widget.imagePath,
                            width: addButtonSize,
                            height: addButtonSize,
                            fit: BoxFit.contain,
                          ),
                        ),
                );
              },
            ),
          ),
        );
      },
    );
  }


  
}
