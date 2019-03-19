import 'package:flutter/material.dart';
import 'package:gympa/models/activities.dart';
import 'package:gympa/theme.dart';
import 'package:intl/intl.dart';

final _weekdays = [
  'MON',
  'TUE',
  'WED',
  'THU',
  'FRI',
  'SAT',
  'SUN',
];

class ActivitiesList extends StatelessWidget {
  final List<Activities> groupedActivities;
  final format = new DateFormat("yyyy-MM-dd");

  ActivitiesList(List<Activities> groupedActivities) : groupedActivities = groupedActivities;
  
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => _getSeparator(index),
      itemCount: groupedActivities.length,
      itemBuilder: (context, index) {
        final Activities ca = groupedActivities[index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(15.0, 6.0, 15.0, 6.0),
              child: Row(
                children: [
                  Container(width: 38, child: Text(_weekdays[ca.date.weekday - 1], style: TextStyles.body(context))),
                  Text(format.format(ca.date), style: TextStyles.body(context, alpha: 150)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIcon(context, 'gym', ca.gym),
                  _buildIcon(context, 'sport', ca.sport),
                  _buildIcon(context, 'running', ca.running),
                  _buildIcon(context, 'walking', ca.walking),
                ],
              ),
            ),
          ]
        );
      },
    );
  }

  _getSeparator(int index) {
    return index > 0 && groupedActivities[index + 1].date.weekday > groupedActivities[index].date.weekday ? 
      Divider(
        color: Colors.tealAccent,
        height: 20.0,
      ) : 
      Divider(
        color: Colors.white10,
        height: 5.0,
      );
  }

  _buildIcon(BuildContext context, String icon, int minutes) {
    return Expanded(
      flex: 1,
      child: Opacity(
        opacity: minutes > 0 ? 1.0 : 0.2,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
              child: Image(image: AssetImage('assets/$icon.png'), height: 20.0)
            ),
            Text('${minutes.toString()} min', style: TextStyles.body(context, alpha: 150)),
          ],
        ),
      ),
    );
  }
}