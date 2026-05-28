import 'package:flutter/material.dart';
import 'package:flutter_demo/resources/constants.dart';
import 'package:flutter_demo/widgets/flowers/flower.dart';
import 'package:flutter_demo/widgets/pots/blue_pot.dart';

class AddButton extends StatefulWidget {
  AddButton({
    super.key,
    required this.builModeActiveNotifier,
    required this.x,
    required this.y,
    required this.item,
    required this.buildBarActiveNotifer,
    required this.index,
    this.onPotPlaced,
    this.onFlowerPlanted,
  });
  final String imagePath = "lib/resources/images/add_smaller.PNG";
  final double x;
  final double y;
  final int index;
  final ValueNotifier<bool> builModeActiveNotifier;
  final ValueNotifier<bool> buildBarActiveNotifer;
  final ValueNotifier<Widget?> item;
  final Function(int index, String template)? onPotPlaced;
  final Function(int index, Flower flower)? onFlowerPlanted;
  bool checking = false;

  @override
  AddButtonState createState() => AddButtonState();
}

class AddButtonState extends State<AddButton> {
  bool isTaken = false;
  Widget? lockedItem;

  @override
  void initState() {
    super.initState();
    widget.item.addListener(() {
      if (widget.item.value != null &&
          widget.checking &&
          widget.item.value is Pot) {
        final originalPot = widget.item.value as Pot;
        final newPot = Pot(
          item: originalPot.item,
          buildBarActiveNotifer: originalPot.buildBarActiveNotifer,
          selectedPotNotifier: originalPot.selectedPotNotifier,
          potTemplate: originalPot.potTemplate,
          onFlowerPlanted: widget.onFlowerPlanted != null
              ? (flower) => widget.onFlowerPlanted!(widget.index, flower)
              : null,
        );
        setState(() {
          isTaken = true;
          lockedItem = newPot;
          widget.item.value = null;
          widget.buildBarActiveNotifer.value = false;
          widget.checking = false;
        });
        widget.onPotPlaced?.call(widget.index, originalPot.potTemplate);
      }
    });
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
                    widget.checking = true;
                    widget.buildBarActiveNotifer.value =
                        !widget.buildBarActiveNotifer.value;
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

  void setPot(Widget? item) {
    if (item != null && !isTaken && item is Pot) {
      setState(() {
        isTaken = true;
        lockedItem = item;
      });
    }
  }

  void loadPot({
    required ValueNotifier<Widget?> item,
    required ValueNotifier<bool> buildBarActiveNotifer,
    required ValueNotifier<PotState?> selectedPotNotifier,
    Flower? initialFlower,
    String potTemplate = 'BLUE',
  }) {
    if (!isTaken) {
      final newPot = Pot(
        item: item,
        buildBarActiveNotifer: buildBarActiveNotifer,
        selectedPotNotifier: selectedPotNotifier,
        potTemplate: potTemplate,
        onFlowerPlanted: widget.onFlowerPlanted != null
            ? (flower) => widget.onFlowerPlanted!(widget.index, flower)
            : null,
        initialPlantedItem: initialFlower,
      );
      setState(() {
        isTaken = true;
        lockedItem = newPot;
      });
    }
  }

  Widget? getPot() {
    return lockedItem;
  }
}
