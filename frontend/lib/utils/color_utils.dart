import 'package:flutter/material.dart';

// A function that converts HexaString color to accepted colors in Flutter
hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll('#', '#');
  if (hexColor.length == 6) {
    hexColor = 'FF' + hexColor;
  }
  return Color(int.parse(hexColor,radix: 16));
}