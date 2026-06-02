import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class UrlConsts{
  static const String flowerService = 'https://group-1-75.pvt.dsv.su.se/flower';
  static const String userService = 'https://group-1-75.pvt.dsv.su.se/user';
}


//===============Paths===============
class ImagePathsConsts{
    static const String addbutton = "lib/resources/images/add_smaller.PNG";
    static const String confirmed = "lib/resources/images/Confirmed.png";
    static const String coins = "lib/resources/images/coin.webp";
    static const String social ='lib/resources/images/Social.png';
    static const String collecotor = 'lib/resources/images/FlowerCollector.png';
    static const String expandbutton = 'lib/resources/images/Expand.png';
    static const String nameBage = 'lib/resources/images/Identity.png';
    static const String flowerIcon = 'lib/resources/images/flower_icon.png';
    static const String likeIcon = 'lib/resources/images/Like.png';
    static const String shopIcon = "lib/resources/images/cart_icon.png";
    static const String homeScreenIcon = "lib/resources/images/home.png";
    static const String cameraIcon = "lib/resources/images/camera_icon.png";
    static const String buildmodeIcon = "lib/resources/images/showel_icon.png";

}


class FlowerImagePathConsts{
  static const String genericFlowerForegroundPath="lib/resources/images/Vitblommamedgulmitten.png";
  static const String genericFlowerBackgroundPath="lib/resources/images/VBVitblommamedgulmitten.png";
  static const String roseFlowerForegroundPath = "lib/resources/images/ros_sticker_kontur.png";
  static const String roseFlowerBackgroundPath = "lib/resources/images/ros_sticker.png";
  static const String sunFlowerForeground = "lib/resources/images/Solros.png";
  static const String sunFlowerBackground = "lib/resources/images/VBSolros.png";
  static const String tulipFlowerForeground = "lib/resources/images/Tulpan.png";
  static const String tulipFlowerBackground = "lib/resources/images/VBTulpan.png";
  static const String woodanemoneFlowerForeground = "lib/resources/images/Vitsippa.png";
  static const String woodanemoneFlowerBackground = "lib/resources/images/VBVitsippa.png";
}

class PotImagePathConsts{
  static const String brown = "lib/resources/images/brown.webp";
  static const String green = "lib/resources/images/green.webp";
  static const String mint = "lib/resources/images/mint.webp";
  static const String pink = "lib/resources/images/pink.webp";
  static const String purple = "lib/resources/images/purple.webp";
  static const String yellow = "lib/resources/images/yellow.webp";
  static const String blue = "lib/resources/images/blue.webp";
}

class AvatarImagePathConsts{
  static const String blue = "lib/resources/images/Avatar_Blue.png";
  static const String pink = "lib/resources/images/Avatar_Pink.png";
  static const String purple = "lib/resources/images/Avatar_Purple.png";
  static const String green = "lib/resources/images/Avatar_Green.png";
  static const String red = "lib/resources/images/Avatar_Red.png";
  static const String yellow = "lib/resources/images/Avatar_Yellow.png";
}




//=============colors==============
const Color mainColor = Color(0xFFFFCAE8);
const Color blockColor = Color(0xFFFFE6F6);
const Color backgroundColor = Color(0xFFB8E9FF); //Enligt Figma
const Color yellowColor = Color(0xFFFFEF89);
const Color purpleColor = Color(0xFFE9C6FF);
const Color greenColor = Color(0xFFAEF7A1);

//Typsnitt för appen
class TextStyles {
  static final TextStyle header = GoogleFonts.nunito(
    fontSize: 30,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static final TextStyle coinsValue = GoogleFonts.nunito(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    color: yellowColor,
  );

  static final TextStyle body = GoogleFonts.nunito(
    fontSize: 30,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle infoText = GoogleFonts.nunito(
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );
}

const Color blueColor = Color(0xFFB8E9FF);
const Color buildBarColor = Color(0xFFFFF4F4);

const double addButtonSize = 300;


