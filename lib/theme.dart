import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle title(BuildContext context) {
    return Theme.of(context).textTheme.body1.copyWith(
      fontSize: 20.0,
      height: 1.4,
      fontWeight: FontWeight.w300,
      color: Color.fromARGB(255, 239, 252, 255),
    );
  }

  static TextStyle body(BuildContext context, {
    fontWeight: FontWeight.w300
  }) {
    return Theme.of(context).textTheme.body1.copyWith(
      fontSize: 14.0,
      height: 1.4,
      fontWeight: fontWeight,
      color: Color.fromARGB(255, 239, 252, 255),
    );
  }
}