import 'package:flutter_demo/widgets/flowers/flower.dart';

class SunFlower extends Flower {
  const SunFlower({super.key, required super.color, required super.name})
    : super(
        frontImage: "lib/resources/images/Solros.png",
        backGround: "lib/resources/images/VBSolros.png",
      );
}
