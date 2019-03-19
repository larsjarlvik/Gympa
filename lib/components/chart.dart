import 'package:flutter/material.dart';
import 'package:gympa/models/activities.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';


class Stack {
  final String id;
  final List<Activity> activites;

  Stack(this.id, this.activites);
}

class Activity {
  final DateTime date;
  final int minutes;
  final charts.Color fillColor;
  final charts.Color borderColor;

  Activity(this.date, this.minutes, this.fillColor, this.borderColor);
}

class Chart extends StatelessWidget {
  final List<Activities> groupedActivities;
  final format = new DateFormat("yyyy-MM-dd");

  static int listLength = -1;
  
  Chart(List<Activities> groupedActivities): groupedActivities = groupedActivities;
  
  @override
  Widget build(BuildContext context) {
    var series = _buildSeries();
    var animate = groupedActivities.length != listLength;
    listLength = groupedActivities.length;

    return new SizedBox(
      height: 200.0,
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(35, 0, 0, 0)
        ),
        child: charts.BarChart(
          series,
          animate: animate,
          defaultRenderer: new charts.BarRendererConfig(
            groupingType: charts.BarGroupingType.grouped, 
            strokeWidthPx: 1.0,
            cornerStrategy: charts.ConstCornerStrategy(0),
          ),
          primaryMeasureAxis:
            charts.NumericAxisSpec(renderSpec: charts.NoneRenderSpec()
          ),
          domainAxis: charts.OrdinalAxisSpec(
            showAxisLine: false,
            renderSpec: charts.NoneRenderSpec()
          ),
        )
      )
    );
  }

  _buildSeries() {
    var stacks = [
      new Stack('Gym', groupedActivities.take(7).map((ga) => new Activity(ga.date, ga.gym, charts.Color.fromHex(code: '#5B317E'), charts.Color.fromHex(code: '#c015e0'))).toList().reversed.toList()),
      new Stack('Sport', groupedActivities.take(7).map((ga) => new Activity(ga.date, ga.sport, charts.Color.fromHex(code: '#68345E'), charts.Color.fromHex(code: '#e71f7f'))).toList().reversed.toList()),
      new Stack('Running', groupedActivities.take(7).map((ga) => new Activity(ga.date, ga.running, charts.Color.fromHex(code: '#1E766C'), charts.Color.fromHex(code: '#09e3a9'))).toList().reversed.toList()),
      new Stack('Walking', groupedActivities.take(7).map((ga) => new Activity(ga.date, ga.walking, charts.Color.fromHex(code: '#5C5F4D'), charts.Color.fromHex(code: '#eb9339'))).toList().reversed.toList()),
    ].toList();

    return stacks.map((stack) => new charts.Series<Activity, String>(
      id: stack.id,
      domainFn: (a, __) => a.date.toString(),
      measureFn: (a, _) => a.minutes,
      data: stack.activites,
      colorFn: (a, __) => a.borderColor,
      fillColorFn: (a, __) => a.fillColor
    )).toList();
  }
}