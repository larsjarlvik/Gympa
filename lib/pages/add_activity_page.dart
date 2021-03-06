
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:gympa/api/requests.dart';
import 'package:gympa/components/spinner.dart';
import 'package:gympa/components/page_container.dart';
import 'package:gympa/components/timer.dart';
import 'package:gympa/models/activities.dart';
import 'package:intl/intl.dart';

class AddActivityPage extends StatefulWidget {
  AddActivityPage({Key key}) : super(key: key);

  @override
  _ActivityListPage createState() => _ActivityListPage();
}

class _ActivityListPage extends State<AddActivityPage> with RouteAware {
  Activities activities;
  bool saving = false;

  @override
  initState() {
    super.initState();
    activities = new Activities(date: DateTime.now());
    saving = false;
  }

  _saveActivity() async {
    if (saving) return;
    if (activities.gym < 1 && activities.sport < 1 && activities.running < 1 && activities.walking < 1) return;

    setState(() => saving = true);
    await addActivities(activities);

    Navigator.pop(context);
  }

  @override
  build(BuildContext context) {
    return PageContent('ADD ACTIVITIES',
      child: Column(
        children: [
          Spinner(saving),
          _buildDatePicker(),
          _buildActivityOption('Gym', activities.gym, (value) => setState(() => activities.gym = value)),
          _buildActivityOption('Sport', activities.sport, (value) => setState(() => activities.sport = value)),
          _buildActivityOption('Running', activities.running, (value) => setState(() => activities.running = value)),
          _buildActivityOption('Walking', activities.walking, (value) => setState(() => activities.walking = value)),
          Flexible(
            child: GridView.count(
              padding: EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 0.0),
              crossAxisCount: 2,
              childAspectRatio: 4,
              crossAxisSpacing: 20.0,
              mainAxisSpacing: 20.0,
              children: [
                Timer(Color(0xffc015e0), AssetImage('assets/gym.png')),
                Timer(Color(0xffe71f7f), AssetImage('assets/sport.png')),
                Timer(Color(0xff09e3a9), AssetImage('assets/running.png')),
                Timer(Color(0xffeb9339), AssetImage('assets/walking.png')),
              ],
            )
          ),
        ],
      ),
      actionButton: FloatingActionButton(
        onPressed: _saveActivity,
        tooltip: 'Save Activities',
        child: Icon(Icons.add),
      ),
    );
  }

  _buildDatePicker() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 30.0),
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
      padding: EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 0.0),
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
