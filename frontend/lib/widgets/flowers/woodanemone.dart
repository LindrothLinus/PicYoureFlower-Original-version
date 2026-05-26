import 'package:flutter_demo/widgets/flowers/flower.dart';

class WoodanemoneFlower extends Flower {
  const WoodanemoneFlower({super.key, required super.color, required super.name})
    : super(
        frontImage: "lib/resources/images/Vitsippa.png",
        backGround: "lib/resources/images/VBVitsippa.png",
      );
}