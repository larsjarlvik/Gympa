import 'dart:convert';

import 'package:gympa/models/activities.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

Future<List<Activities>> listActivites() async {
    var response = await get(
      'https://gympa-3e24.restdb.io/rest/activities',
      headers: {
        'content-type': 'application/json',
        'x-apikey': '5c83c653cac6621685acbd04',
      }
    );

    var rawActivites = json.decode(response.body);
    var parsedActivities = new List<Activities>();
    rawActivites.forEach((p) => parsedActivities.add(Activities.fromJson(p)));
    parsedActivities.sort((Activities a, Activities b) => b.date.compareTo(a.date));

    return parsedActivities;
}

Future<void> addActivities(Activities activities) async {
  final format = new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

  final Map<String, String> body = {
    'date': format.format(activities.date),
    'gym': activities.gym.toString(),
    'running': activities.running.toString(),
    'walking': activities.walking.toString(),
    'sport': activities.sport.toString(),
  };
  
  await post(
    'https://gympa-3e24.restdb.io/rest/activities',
    body: json.encode(body),
    headers: {
      'content-type': 'application/json',
      'x-apikey': '5c83c653cac6621685acbd04',
    }
  );
}