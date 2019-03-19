import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

enum Groupings {
  Daily,
  Weekly,
  Monthly,
}

class Activities {
  DateTime date;
  int gym;
  int sport;
  int running;
  int walking;

  Activities({this.date, this.gym = 0, this.sport = 0, this.running = 0, this.walking = 0});

  factory Activities.fromJson(Map<String, dynamic> json) {
    final parsedDate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(json['date']);

    return Activities(
      date: DateTime(parsedDate.year, parsedDate.month, parsedDate.day),
      gym: json['gym'],
      sport: json['sport'],
      running: json['running'],
      walking: json['walking'],
    );
  }
}

List<Activities> group(List<Activities> activities, Groupings grouping) {
    switch (grouping) {
      case Groupings.Daily:
        return _groupByDay(activities);
      case Groupings.Weekly:
        return _groupByWeek(activities);
      case Groupings.Monthly:
        return _groupByMonth(activities);
    }
}

List<Activities> _groupByDay(List<Activities> activities) {
  final groupedActivites = groupBy(activities, (Activities a) => a.date);
  return _sumActivities(groupedActivites);
}

List<Activities> _groupByWeek(List<Activities> activities) {
  final groupedActivites = groupBy(activities, (Activities a) => a.date.subtract(Duration(days: a.date.weekday)));
  return _sumActivities(groupedActivites);
}

List<Activities> _groupByMonth(List<Activities> activities) {
  final groupedActivites = groupBy(activities, (Activities a) => a.date.subtract(Duration(days: a.date.day - 1)));
  return _sumActivities(groupedActivites);
}

List<Activities> _sumActivities(Map<DateTime, List<Activities>> activities) {
  final summedActivites = new List<Activities>();

  activities.forEach((d, a) {
    summedActivites.add(Activities(
      date: d,
      gym: a.fold(0, (sum, a) => sum += a.gym),
      sport: a.fold(0, (sum, a) => sum += a.sport),
      running: a.fold(0, (sum, a) => sum += a.running),
      walking: a.fold(0, (sum, a) => sum += a.walking),
    ));
  });

  return summedActivites;
}
