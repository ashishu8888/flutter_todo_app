import 'package:flutter/material.dart';

const Color bluishclr = Color(0xFF4e5ae8);
const Color yellowishclr = Color(0xFFFFB746);
const Color pinkclr = Color(0xFFff4667);
const Color whiteclr = Colors.white;
const primaryclr = bluishclr;
const Color darkGreyClr = Color(0xFF121212);
Color darkHeaderClr = Color(0xFF424242);

class Themes {
  static final light =
      ThemeData(primaryColor: primaryclr, brightness: Brightness.light);
  static final dark =
      ThemeData(primaryColor: darkGreyClr, brightness: Brightness.dark);
}
