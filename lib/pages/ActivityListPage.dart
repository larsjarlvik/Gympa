import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gympa/models/Activities.dart';
import 'package:gympa/pages/AddActivityPage.dart';
import 'package:http/http.dart';

class ActivityListPage extends StatefulWidget {
  final RouteObserver routeObserver;

  ActivityListPage(RouteObserver routeObserver) : routeObserver = routeObserver;

  @override
  _ActivityListPage createState() => _ActivityListPage(routeObserver);
}

class _ActivityListPage extends State<ActivityListPage> with RouteAware  {
  var activities = new List<Activities>();
  var loading = false;

  final RouteObserver routeObserver;
  
  _ActivityListPage(RouteObserver routeObserver) :
    routeObserver = routeObserver;

  void _addActivity() {
    Navigator.push(context, new MaterialPageRoute(
      builder: (context) => new AddActivityPage()
    ));
  }

  void _getActivites() async {
    setState(() {
      loading = true; 
    });

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

    setState(() {
      activities = parsedActivities;
      loading = false;
    });
  }

  @override
  initState() {
    super.initState();
    _getActivites();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPopNext() {
    _getActivites();
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('GYMPA'),
      ),
      body: Column(
        children: [
          _buildLoadingSpinner(),
          new Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
              child: _buildActivitiesList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addActivity,
        tooltip: 'Add Activity',
        child: Icon(Icons.add),
      ),
    );
  }

  _buildActivitiesList() {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Colors.white10,
      ),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 11.0, 0.0, 12.0),
              child: Text('${activities[index].date.split('T')[0]}', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 13.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIcon('gym', activities[index].gym),
                  _buildIcon('sport', activities[index].sport),
                  _buildIcon('running', activities[index].running),
                  _buildIcon('walking', activities[index].walking),
                ],
              ),
            ),
          ]
        );
      },
    );
  }

  _buildIcon(String icon, int minutes) {
    return Opacity(
      opacity: minutes > 0 ? 1.0 : 0.2,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
            child: Image(image: AssetImage('assets/$icon.png'), height: 20.0)
          ),
          Text('${minutes.toString()} min', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
  
  _buildLoadingSpinner() {
    return loading ? LinearProgressIndicator() : SizedBox(height: 6.5);
  }
}
