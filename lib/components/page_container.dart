import 'package:flutter/material.dart';
import 'package:gympa/theme.dart';


class PageContent extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget actionButton;

  PageContent(String title, {
    this.child, 
    this.actionButton
  }) : this.title = title;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          stops: [0.0, 1.0],
          colors: [Color.fromARGB(255, 41, 69, 83), Color.fromARGB(255, 38, 44, 56)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Text(title, style: TextStyles.title(context)),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: child,
        floatingActionButton: actionButton,
      ),
    );
  }
}
