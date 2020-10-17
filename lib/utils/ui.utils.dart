import 'package:flutter/material.dart';

///A class that provides a function that uses Hex colors and give back its flutter color
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  /// Getting the hex string from a Color class
  ///
  /// `c` const dart [Color]
  static String getHexFromColor(Color c) {
    String hexVal = c.value.toRadixString(16);
    return '#$hexVal';
  }

  /// Use `hexColor` hex string instead of the dart's [Color] class
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}