import 'package:chat_application/core/color_pallet.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomDividor extends StatelessWidget {
  CustomDividor({super.key, required this.text});
  String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: themeColor,
            thickness: 1,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Divider(
            color: themeColor,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
