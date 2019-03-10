import 'package:intl/intl.dart';

class Activities {
  DateTime date;
  int gym;
  int sport;
  int running;
  int walking;

  Activities({this.date, this.gym = 0, this.sport = 0, this.running = 0, this.walking = 0});

  factory Activities.fromJson(Map<String, dynamic> json) {
    final format = new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

    return Activities(
      date: format.parse(json['date']),
      gym: json['gym'],
      sport: json['sport'],
      running: json['running'],
      walking: json['walking'],
    );
  }
}
