import 'package:flutter_demo/resources/constants.dart';
import 'package:flutter_demo/widgets/flowers/flower.dart';

class SunFlower extends Flower {
  const SunFlower({super.key, required super.color, required super.name, super.id})
    : super(
        frontImage: FlowerImagePathConsts.sunFlowerForeground,
        backGround: FlowerImagePathConsts.sunFlowerBackground,
      );
}