import 'package:flutter_demo/widgets/flowers/flower.dart';

class RoseFlower extends Flower {
  const RoseFlower({super.key, required super.color})
    : super(
        frontImage: "lib/resources/images/ros_sticker_kontur.png",
        backGround: "lib/resources/images/ros_sticker.png",
      );
}
