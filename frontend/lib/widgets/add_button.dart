import 'package:flutter/material.dart';
import 'package:flutter_demo/resources/constants.dart';
import 'package:flutter_demo/widgets/pots/blue_pot.dart';

class AddButton extends StatefulWidget {
  AddButton({super.key, required this.builModeActiveNotifier, required this.x, required this.y, required this.item});
  final String imagePath = "lib/resources/images/Add.webp";
  final double x;
  final double y;
  final ValueNotifier<bool> builModeActiveNotifier;
  final ValueNotifier<Widget?> item;

  @override
  AddButtonState createState() => AddButtonState();
}

class AddButtonState extends State<AddButton> {
  bool isTaken = false;
  Widget? lockedItem;

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
                    if (item != null && !isTaken&&item is Pot) {
                      setState(() {
                        isTaken = true;
                        lockedItem = item; // Lock the current value
                      });
                    }
                  },
                  child: isTaken
                      ? FittedBox(
        fit: BoxFit.contain,
        child: lockedItem,
      )
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