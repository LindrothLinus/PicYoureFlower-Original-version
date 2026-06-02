import 'package:flutter_demo/resources/constants.dart';
import 'package:flutter_demo/widgets/flowers/flower.dart';

class WoodanemoneFlower extends Flower {
  const WoodanemoneFlower({super.key, required super.color, required super.name, super.id})
    : super(
        frontImage: FlowerImagePathConsts.woodanemoneFlowerForeground,
        backGround: FlowerImagePathConsts.woodanemoneFlowerBackground
      );
}