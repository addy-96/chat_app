import 'package:flutter/material.dart';

enum snackType { success, failure }

dynamic getSnack(String message, BuildContext context, snackType type) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: type == snackType.success ? Colors.green : Colors.red,
      ),
   );
