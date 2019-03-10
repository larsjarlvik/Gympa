import 'package:flutter/material.dart';
import 'package:gympa/models/activities.dart';
import 'package:gympa/pages/add_activity_page.dart';
import 'package:gympa/api/requests.dart';
import 'package:intl/intl.dart';

class ActivityListPage extends StatefulWidget {
  final RouteObserver routeObserver;

  ActivityListPage(RouteObserver routeObserver) : routeObserver = routeObserver;

  @override
  _ActivityListPage createState() => _ActivityListPage(routeObserver);
}

class _ActivityListPage extends State<ActivityListPage> with RouteAware  {
  var activities = new List<Activities>();
  var loading = false;
  final format = new DateFormat("yyyy-MM-dd");

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

    var requestedActivies = await listActivites();

    setState(() {
      activities = groupActivities(requestedActivies);
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
              child: Text(format.format(activities[index].date), style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
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
    return Expanded(
      flex: 1,
      child: Opacity(
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
      ),
    );
  }
  
  _buildLoadingSpinner() {
    return loading ? LinearProgressIndicator() : SizedBox(height: 6.5);
  }
}
