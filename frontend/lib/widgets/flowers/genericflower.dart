import 'package:flutter_demo/widgets/flowers/flower.dart';

class GenericFlower extends Flower {
  const GenericFlower({super.key, required super.color, required super.name})
    : super(
        frontImage: "lib/resources/images/Vitblommamedgulmitten.png",
        backGround: "lib/resources/images/VBVitblommamedgulmitten.png",
      );
}
