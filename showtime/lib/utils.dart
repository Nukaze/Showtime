import 'dart:math';

import 'package:flutter/material.dart';

void alertDialog(BuildContext context, String title, String message,
    {String acceptText = "Ok", String cancelText = "Cancel", VoidCallback? onAccept, VoidCallback? onCancel}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: onAccept ?? () => Navigator.of(context).pop(),
              child: Text(acceptText),
            ),
            TextButton(
              onPressed: onCancel ?? () => Navigator.of(context).pop(),
              child: Text(cancelText),
            ),
          ],
        );
      });
}

int randomNumber(int? min, int? max) {
  final rand = Random();
  if (min == null && max == null) {
    return rand.nextInt(100);
  }

  if (min == null || max == null) {
    return throw ArgumentError('Both min and max must be provided');
  }

  return min + rand.nextInt(max - min + 1);
}
