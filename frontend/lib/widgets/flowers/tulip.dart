import 'package:flutter_demo/resources/constants.dart';
import 'package:flutter_demo/widgets/flowers/flower.dart';

class TulipFlower extends Flower {
  const TulipFlower({super.key, required super.color, required super.name, super.id})
    : super(
        frontImage: FlowerImagePathConsts.tulipFlowerForeground,
        backGround: FlowerImagePathConsts.tulipFlowerBackground,
      );
}