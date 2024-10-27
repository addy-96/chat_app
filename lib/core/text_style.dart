import 'package:chat_application/core/color_pallet.dart';
import 'package:flutter/material.dart';

class CustomTextStyle {
  static TextStyle getCustomStyle(double size) => TextStyle(
        fontSize: size,
        color: themeColor,
        fontWeight: FontWeight.w400,
        letterSpacing: 4,
      );

  static TextStyle getButtonText() => const TextStyle(
        fontSize: 22,
        color: Colors.white,
      );

  static TextStyle normaltext(double size, Color color) => TextStyle(
        fontSize: size,
        color: color,
      );
}
