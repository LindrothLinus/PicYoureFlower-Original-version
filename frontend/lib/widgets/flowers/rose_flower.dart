import 'package:flutter_demo/resources/constants.dart';
import 'package:flutter_demo/widgets/flowers/flower.dart';

class RoseFlower extends Flower {
  const RoseFlower({super.key, required super.color, required super.name, super.id})
    : super(
        frontImage: roseFlowerForegroundPath,
        backGround: roseFlowerBackgroundPath,
      );
}