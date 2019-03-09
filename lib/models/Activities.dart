class Activities {
  final String date;
  final int gym;
  final int sport;
  final int running;
  final int walking;

  Activities({this.date, this.gym, this.sport, this.running, this.walking});

  factory Activities.fromJson(Map<String, dynamic> json) {
    return Activities(
      date: json['date'],
      gym: json['gym'],
      sport: json['sport'],
      running: json['running'],
      walking: json['walking'],
    );
  }
}
