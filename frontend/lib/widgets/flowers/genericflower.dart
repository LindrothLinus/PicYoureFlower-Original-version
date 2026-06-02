import 'package:flutter_demo/resources/constants.dart';
import 'package:flutter_demo/widgets/flowers/flower.dart';

class GenericFlower extends Flower {
  const GenericFlower({super.key, required super.color, required super.name, super.id})
    : super(
        frontImage: FlowerImagePathConsts.genericFlowerForegroundPath,
        backGround: FlowerImagePathConsts.genericFlowerBackgroundPath,
      );
}