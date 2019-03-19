import 'dart:async' show Future;
import 'dart:convert' show json;

import 'package:flutter/services.dart';

class Config {
  final String url;
  final String apikey;

  Config({ this.url = "", this.apikey = "" });

  factory Config.fromJson(Map<String, dynamic> jsonMap) {
    return new Config(url: jsonMap["url"], apikey: jsonMap["api_key"]);
  }
}

class ConfigLoader {
  final String configPath;

  ConfigLoader({ this.configPath });

  Future<Config> load() {
    return rootBundle.loadStructuredData<Config>(this.configPath, (jsonStr) async => Config.fromJson(json.decode(jsonStr)));
  }
}
