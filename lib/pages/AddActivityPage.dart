import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart';

class AddActivityPage extends StatefulWidget {
  AddActivityPage({Key key}) : super(key: key);

  @override
  _ActivityListPage createState() => _ActivityListPage();
}

class _ActivityListPage extends State<AddActivityPage> with RouteAware  {
  Activity walking;
  Activity running;
  Activity gym;
  Activity sport;
  DateTime date;
  bool saving = false;

  @override
  initState() {
    super.initState();
    walking = new Activity('Walking', 0);
    running = new Activity('Running', 0);
    gym = new Activity('Gym', 0);
    sport = new Activity('Sport', 0);
    date = DateTime.now();
    saving = false;
  }

  _saveActivity() async {
    if (gym.minutes < 1 && sport.minutes < 1 && running.minutes < 1 && walking.minutes < 1) return;

    setState(() {
     saving = true;
    });

    Map<String, String> body = {
      'date': '${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      'gym': gym.minutes.toString(),
      'running': running.minutes.toString(),
      'walking': walking.minutes.toString(),
      'sport': sport.minutes.toString(),
    };
    
    await post(
      'https://gympa-3e24.restdb.io/rest/activities',
      body: json.encode(body),
      headers: {
        'content-type': 'application/json',
        'x-apikey': '5c83c653cac6621685acbd04',
      }
    );

    Navigator.pop(context);
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Activities'),
      ),
      body: Column(
        children: [
          _buildSavingSpinner(),
          _buildDatePicker(),
          _buildActivityOption(gym),
          _buildActivityOption(sport),
          _buildActivityOption(running),
          _buildActivityOption(walking)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveActivity,
        tooltip: 'Save Activities',
        child: Icon(Icons.add),
      ),
    );
  }

  _buildSavingSpinner() {
    return saving ? LinearProgressIndicator() : SizedBox(height: 6.5);
  }

  _buildDatePicker() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Workout Date', style: TextStyle(color: Colors.white70)),
          DateTimePickerFormField(
            dateOnly: true,
            format: DateFormat('yyyy-MM-dd'),
            initialDate: DateTime.now(),
            initialValue: DateTime.now(),
            onChanged: (dt) {
              print(dt);
              setState(() { date = dt; });
            },
          ),
        ]
      ),
    );
  }

  _buildActivityOption(Activity activity) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.0, 40.0, 8.0, 0.0),
      child: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(8.0, 0.0, 14.0, 5.0),
          child: 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                      child: Image(image: AssetImage('assets/${activity.name.toLowerCase()}.png'), height: 20.0)
                    ),
                    Text(activity.name, style: TextStyle(color: Colors.white70)),
                  ],
                ),
                Text('${activity.minutes.toString()} minutes')
              ],
            ),
        ),
        Slider(
          inactiveColor: Colors.white24,
          activeColor: Colors.tealAccent,
          min: 0.0,
          max: 120.0,
          onChanged: (newRating) {
            setState(() => activity.minutes = newRating.toInt());
          },
          value: activity.minutes.toDouble(),
        ),
      ]),
    );
  }
}

class Activity {
  int minutes;
  String name;
  
  Activity(this.name, this.minutes);
}
