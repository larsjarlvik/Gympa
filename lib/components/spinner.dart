import 'package:flutter/material.dart';

class Spinner extends StatelessWidget {
  final bool loading;

  Spinner(bool loading) : loading = loading;
  
  @override
  Widget build(BuildContext context) {
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
}
