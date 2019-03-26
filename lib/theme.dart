import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle body(BuildContext context, {
    fontWeight: FontWeight.w300,
    alpha: 255
  }) {
    return Theme.of(context).textTheme.body1.copyWith(
      fontSize: 14.0,
      height: 1.4,
      fontWeight: fontWeight,
      color: Color.fromARGB(alpha, 239, 252, 255),
    );
  }
  static TextStyle title(BuildContext context) {
    return  body(context, fontWeight: FontWeight.w300).copyWith(
      fontSize: 20.0,
    );
  }

  static TextStyle fixed(BuildContext context, {
    fontWeight: FontWeight.w600,
    alpha: 255
  }) {
    return body(context, fontWeight: fontWeight).copyWith(
      fontFamily: 'Hasklig',
    );
  }
}