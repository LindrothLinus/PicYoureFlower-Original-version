import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/flowers/flower.dart';
import 'package:flutter_demo/widgets/flowers/rose_flower.dart';

class Pot extends StatefulWidget {
  Pot({
    Key? key,
    required this.item,
    required this.buildBarActiveNotifer,
    required this.selectedPotNotifier,
    this.id,
    this.onFlowerPlanted,
    this.initialPlantedItem,
    this.potTemplate = 'BLUE',
    this.buildModeActiveNotifier,
    this.onFlowerInfoRequested,
    this.onBuildModeTap,
  }) : super(key: key ?? UniqueKey());

  final int? id;
  final String potTemplate;
  final ValueNotifier<Widget?> item;
  final ValueNotifier<bool> buildBarActiveNotifer;
  final ValueNotifier<PotState?> selectedPotNotifier;
  final Function(Flower flower)? onFlowerPlanted;
  final Flower? initialPlantedItem;
  final ValueNotifier<bool>? buildModeActiveNotifier;
  final Function(Flower flower)? onFlowerInfoRequested;
  final VoidCallback? onBuildModeTap;

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

  String get _potImagePath {
    switch (widget.potTemplate) {
      case 'BROWN':     return "lib/resources/images/brown.webp";
      case 'GREEN':     return "lib/resources/images/green.webp";
      case 'TURQUOISE': return "lib/resources/images/mint.webp";
      case 'PINK':      return "lib/resources/images/pink.webp";
      case 'PURPLE':    return "lib/resources/images/purple.webp";
      case 'YELLOW':    return "lib/resources/images/yellow.webp";
      default:          return "lib/resources/images/blue.webp";
    }
  }

  void _onItemChanged() {
    if (widget.item.value != null && widget.item.value is Flower && isSelected) {
      if (mounted) {
        final flower = widget.item.value as Flower;
        setState(() {
          plantedItem = flower;
          widget.item.value = null;
          widget.buildBarActiveNotifer.value = false;
          widget.selectedPotNotifier.value = null;
        });
        widget.onFlowerPlanted?.call(flower);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialPlantedItem != null) {
      plantedItem = widget.initialPlantedItem;
    }
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
        final bool buildModeActive = widget.buildModeActiveNotifier?.value ?? true;
        if (buildModeActive) {
          widget.onBuildModeTap?.call();
          widget.selectedPotNotifier.value = this;
          widget.buildBarActiveNotifer.value = true;
        } else {
          if (plantedItem is Flower) {
            widget.onFlowerInfoRequested?.call(plantedItem as Flower);
          }
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Image.asset(_potImagePath, fit: BoxFit.fill),
          Positioned(
            top: -60,
            left: plantedItem is RoseFlower ? 0 : 15,
            right: 0,
            child: plantedItem ?? Container(),
          ),
        ],
      ),
    );
  }
}