import 'package:flutter_demo/widgets/flowers/flower.dart';

class TulipFlower extends Flower {
  const TulipFlower({super.key, required super.color, required super.name})
    : super(
        frontImage: "lib/resources/images/Tulpan.png",
        backGround: "lib/resources/images/VBTulpan.png",
      );
}
