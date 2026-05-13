import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color mainColor = Color(0xFFFFCAE8);
const Color blockColor = Color(0xFFFFE6F6);
const Color backgroundColor = Color(0xFFB8E9FF); //Enligt Figma
const Color yellowColor = Color(0xFFFFEF89);

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
}
const Color blueColor = Color(0xFFB8E9FF);
const Color buildBarColor = Color(0xFFFFF4F4);


const double addButtonSize = 100; 
