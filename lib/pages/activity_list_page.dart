import 'package:flutter/material.dart';
import 'package:gympa/components/activites_list.dart';
import 'package:gympa/components/chart.dart';
import 'package:gympa/components/spinner.dart';
import 'package:gympa/components/page_container.dart';
import 'package:gympa/models/activities.dart';
import 'package:gympa/pages/add_activity_page.dart';
import 'package:gympa/api/requests.dart';

class ActivityListPage extends StatefulWidget {
  final RouteObserver routeObserver;

  ActivityListPage(RouteObserver routeObserver) : routeObserver = routeObserver;

  @override
  _ActivityListPage createState() => _ActivityListPage(routeObserver);
}

class _ActivityListPage extends State<ActivityListPage> with RouteAware  {
  var activities = new List<Activities>();
  var activeGrouping = Groupings.Daily;
  var groupedActivities = new List<Activities>();
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

    var requestedActivies = await listActivites();

    setState(() {
      activities = requestedActivies;
      groupedActivities = group(activities, activeGrouping);
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
    return PageContent('GYMPA', 
      child: Column(
        children: [
          _buildGroupPills(),
          Spinner(loading),
          Chart(groupedActivities),
          Divider(
            height: 1.0,
            color: Colors.white10,
          ),
          Expanded(
            child: ActivitiesList(groupedActivities),
          ),
        ],
      ),
      actionButton: FloatingActionButton(
        onPressed: _addActivity,
        tooltip: 'Add Activity',
        child: Icon(Icons.add),
      ),
    );
  }

  _buildGroupPills() {
    return Row(
      children: [
        _buildPill(Groupings.Daily, 'Daily', () => setState(() { groupedActivities = group(activities, Groupings.Daily); activeGrouping = Groupings.Daily; })),
        _buildPill(Groupings.Weekly, 'Weekly', () => setState(() { groupedActivities = group(activities, Groupings.Weekly); activeGrouping = Groupings.Weekly; })),
        _buildPill(Groupings.Monthly, 'Monthly', () => setState(() { groupedActivities = group(activities, Groupings.Monthly); activeGrouping = Groupings.Monthly; }))
      ],
    );
  }

  _buildPill(Groupings g, String text, VoidCallback callback) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 6.0),
        child: FlatButton(
          color: g == activeGrouping ? Colors.tealAccent.withAlpha(120) : Colors.transparent,
          child: Text(text),
          onPressed: () => callback(),
        ),
      )
    );
  }
}
