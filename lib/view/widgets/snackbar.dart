
import 'package:firebase_social_auth/helpers/colors.dart';
import 'package:flutter/material.dart';

void openSnackBar(context, snackMessage, color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      action: SnackBarAction(
        label: "OK",
        textColor: cWhiteColor,
        onPressed: () {},
      ),
      content: Text(
        snackMessage,
        style: const TextStyle(fontSize: 14),
      ),
    ),
  );
}
