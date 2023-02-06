import 'package:flutter/material.dart';

class ColorApp {
  static const Color primary = Color(0xff027FFF);
  static const Color secondary = Color(0xff17234D);
  static const Color accent1 = Color(0xffD0F6FF);
  static const Color accent2 = Color(0xff19E8E2);
  static Color taskLevelColor(String level) {
    switch (level) {
      case 'important':
        return Colors.red;
      case 'normal':
        return Colors.blue;
      case 'not too important':
        return Colors.greenAccent;
      default:
        return Colors.white;
    }
  }
}
