import 'package:chat_application/core/color_pallet.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextfield extends StatelessWidget {
  CustomTextfield({
    super.key,
    required this.hintText,
    required this.textController,
  });
  String hintText;
  TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        hintText: hintText,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: themeColor,
            width: 4,
          ),
        ),
      ),
      validator: (value) {
        if (hintText == 'Username') {
          if (value == null ||
              value.isEmpty ||
              (value.length < 8 && value.length > 15)) {
            return 'Username Should be 8-15 characterS long.';
          }
        }
        if (hintText == 'Email') {
          if (value == null || value.isEmpty || !value.contains('@')) {
            return 'Invalid email address !';
          }
        } else {
          if (value == null || value.isEmpty) {
            return 'Please Enter Something';
          }
        }
        return null;
      },
    );
  }
}
