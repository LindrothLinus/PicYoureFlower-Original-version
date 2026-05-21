import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/flowers/flower.dart';

class Pot extends StatefulWidget {
  Pot({
    Key? key,
    required this.item,
    required this.buildBarActiveNotifer,
    required this.selectedPotNotifier,
  }) : super(key: key ?? UniqueKey());

  final ValueNotifier<Widget?> item;
  final ValueNotifier<bool> buildBarActiveNotifer;
  final ValueNotifier<PotState?> selectedPotNotifier;

  Widget? plantedItem;
  @override
  PotState createState() => PotState();

  Widget? getPlantedItem(){
    return plantedItem;
  }
}

class PotState extends State<Pot> {
  Widget? plantedItem;

  bool get isSelected => widget.selectedPotNotifier.value == this;

  void _onItemChanged() {
    if (widget.item.value != null && widget.item.value is Flower && isSelected) {
      if (mounted) {
        setState(() {
          plantedItem = widget.item.value;
          widget.item.value = null;
          widget.buildBarActiveNotifer.value = false;
          widget.selectedPotNotifier.value = null;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    widget.item.addListener(_onItemChanged);
  }

  @override
  void dispose() {
    widget.item.removeListener(_onItemChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.selectedPotNotifier.value = this;
        widget.buildBarActiveNotifer.value = true;
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Image.asset("lib/resources/images/blue.webp", fit: BoxFit.fill),
          Positioned(
            top: -60,
            left: 0,
            right: 0,
            child: plantedItem ?? Container(),
          ),
        ],
      ),
    );
  }
}