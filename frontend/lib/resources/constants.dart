import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class UrlConsts{
  static const String flowerService = 'https://group-1-75.pvt.dsv.su.se/flower';
  static const String userService = 'https://group-1-75.pvt.dsv.su.se/user';
}


//===============Paths===============
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


