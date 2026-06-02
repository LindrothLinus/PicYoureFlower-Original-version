import 'package:flutter/material.dart';
import 'package:flutter_demo/resources/constants.dart';
import 'package:flutter_demo/widgets/carousel.dart';
import 'package:flutter_demo/widgets/flowers/flower.dart';
import 'package:flutter_demo/widgets/pot.dart';

class BuildBar extends StatefulWidget {
  const BuildBar({
    super.key,
    required this.onFlowerSelected,
    required this.onPotSelected,
    required this.visibilityNotifier,
    required this.flowers,
    required this.pots,
  });

  final ValueNotifier<bool> visibilityNotifier;
  final Function(Widget) onFlowerSelected;
  final Function(Widget) onPotSelected;

  final List<Flower> flowers;
  final List<Pot> pots;

  @override
  BuildBarState createState() => BuildBarState();
}

class BuildBarState extends State<BuildBar> {
  @override
  Widget build(BuildContext context) {
    const String flowerText = "  Your flowers:";
    const String potText = "  Your pots:";

    return ValueListenableBuilder<bool>(
      valueListenable: widget.visibilityNotifier,
      builder: (context, isVisible, child) {
        return Visibility(
          visible: isVisible,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: buildBarColor,
            ),
            child: FractionallySizedBox(
              widthFactor: 1,
              heightFactor: 0.5,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(flowerText, style: TextStyles.body),
                  Carousel(
                    onItemSelected: widget.onFlowerSelected,
                    items: widget.flowers,
                  ),
                  Text(potText, style: TextStyles.body),
                  Carousel(
                    onItemSelected: widget.onPotSelected,
                    items: widget.pots,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
