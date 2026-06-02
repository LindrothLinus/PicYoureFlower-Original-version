import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class UrlConst{
  static const String flowerService = 'https://group-1-75.pvt.dsv.su.se/flower';
  static const String userService = 'https://group-1-75.pvt.dsv.su.se/user';
}


//===============Paths===============
const String likedPath = "lib/resources/images/SentLike.png";


const String genericFlowerForegroundPath="lib/resources/images/Vitblommamedgulmitten.png";
const String genericFlowerBackgroundPath="lib/resources/images/VBVitblommamedgulmitten.png";
const String roseFlowerForegroundPath = "lib/resources/images/ros_sticker_kontur.png";
const String roseFlowerBackgroundPath = "lib/resources/images/ros_sticker.png";



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


