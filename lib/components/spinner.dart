import 'package:flutter/material.dart';

spinner(bool loading) {
  if (loading) {
    return SizedBox(
      child: LinearProgressIndicator(
        backgroundColor: Colors.white10
      ), 
      height: 1.0
    );
  }

  return Divider(
    height: 1.0,
    color: Colors.white10,
  );
}