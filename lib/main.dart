import 'package:flutter/material.dart';
import 'package:gympa/pages/activity_list_page.dart';

void main() => runApp(Gympa());

class Gympa extends StatelessWidget {
  final routeObserver = new RouteObserver<PageRoute>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GYMPA',
      navigatorObservers: [routeObserver],
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Cabin'
      ),
      home: new Scaffold(
        body: ActivityListPage(routeObserver),
      ),
    );
  }
}
