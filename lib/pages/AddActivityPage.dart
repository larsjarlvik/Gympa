import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:gympa/api/requests.dart';
import 'package:gympa/models/Activities.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart';

class AddActivityPage extends StatefulWidget {
  AddActivityPage({Key key}) : super(key: key);

  @override
  _ActivityListPage createState() => _ActivityListPage();
}

class _ActivityListPage extends State<AddActivityPage> with RouteAware  {
  Activities activities;
  bool saving = false;

  @override
  initState() {
    super.initState();
    activities = new Activities(date: DateTime.now());
    saving = false;
  }

  _saveActivity() async {
    if (activities.gym < 1 && activities.sport < 1 && activities.running < 1 && activities.walking < 1) return;

    setState(()  => saving = true);
    await addActivities(activities);

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
          _buildActivityOption('Gym', activities.gym, (value) => setState(() => activities.gym = value)),
          _buildActivityOption('Sport', activities.sport, (value) => setState(() => activities.sport = value)),
          _buildActivityOption('Running', activities.running, (value) => setState(() => activities.running = value)),
          _buildActivityOption('Walking', activities.walking, (value) => setState(() => activities.walking = value))
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
              setState(() { activities.date = dt; });
            },
          ),
        ]
      ),
    );
  }

  _buildActivityOption(String name, int minutes, void Function(int) callback) {
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
                      child: Image(image: AssetImage('assets/${name.toLowerCase()}.png'), height: 20.0)
                    ),
                    Text(name, style: TextStyle(color: Colors.white70)),
                  ],
                ),
                Text('${minutes.toString()} minutes')
              ],
            ),
        ),
        Slider(
          inactiveColor: Colors.white24,
          activeColor: Colors.tealAccent,
          min: 0.0,
          max: 120.0,
          onChanged: (newRating) {
            callback(newRating.toInt());
          },
          value: minutes.toDouble(),
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
