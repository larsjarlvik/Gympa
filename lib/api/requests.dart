import 'dart:convert';

import 'package:gympa/api/config.dart';
import 'package:gympa/models/activities.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

Config _config;

_verifyConfig() async {
  if(_config == null) {
    final loader = new ConfigLoader(configPath: 'assets/config.json');
    _config = await loader.load();
  }
}

Future<List<Activities>> listActivites() async {
  await _verifyConfig();

  var response = await get(
    _config.url,
    headers: {
      'content-type': 'application/json',
      'x-apikey': _config.apikey,
    }
  );

  var rawActivites = json.decode(response.body);
  var parsedActivities = new List<Activities>();
  rawActivites.forEach((p) => parsedActivities.add(Activities.fromJson(p)));
  parsedActivities.sort((Activities a, Activities b) => b.date.compareTo(a.date));

  return parsedActivities;
}

Future<void> addActivities(Activities activities) async {
  await _verifyConfig();
  final format = new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

  final Map<String, String> body = {
    'date': format.format(activities.date),
    'gym': activities.gym.toString(),
    'running': activities.running.toString(),
    'walking': activities.walking.toString(),
    'sport': activities.sport.toString(),
  };
  
  await post(
    _config.url,
    body: json.encode(body),
    headers: {
      'content-type': 'application/json',
      'x-apikey': _config.apikey,
    }
  );
}