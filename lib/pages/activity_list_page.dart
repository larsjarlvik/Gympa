import 'package:flutter/material.dart';
import 'package:gympa/components/page_container.dart';
import 'package:gympa/models/activities.dart';
import 'package:gympa/pages/add_activity_page.dart';
import 'package:gympa/api/requests.dart';
import 'package:gympa/theme.dart';
import 'package:intl/intl.dart';

enum Groupings {
  Daily,
  Weekly,
  Monthly,
}

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
      activities = requestedActivies;
      groupedActivities = groupByDay(requestedActivies);
      activeGrouping = Groupings.Daily;
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
    return pageContent(context, 'GYMPA', 
      Column(
        children: [
          _buildLoadingSpinner(),
          _buildGroupPills(),
          new Expanded(
            child: _buildActivitiesList(),
          ),
        ],
      ),
      FloatingActionButton(
        onPressed: _addActivity,
        tooltip: 'Add Activity',
        child: Icon(Icons.add),
      ),
    );
  }

  _buildGroupPills() {
    return Row(
      children: [
        _buildPill(Groupings.Daily, 'Daily', () => setState(() { groupedActivities = groupByDay(activities); activeGrouping = Groupings.Daily; })),
        _buildPill(Groupings.Weekly, 'Weekly', () => setState(() { groupedActivities = groupByWeek(activities); activeGrouping = Groupings.Weekly; })),
        _buildPill(Groupings.Monthly, 'Monthly', () => setState(() { groupedActivities = groupByMonth(activities); activeGrouping = Groupings.Monthly; }))
      ],
    );
  }

  _buildPill(Groupings g, String text, VoidCallback callback) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
        child: MaterialButton(
          clipBehavior: Clip.antiAlias,
          elevation: g == activeGrouping ? 4.0 : 0.0,
          color: g == activeGrouping ? Colors.teal : Colors.transparent,
          child: Text(text),
          onPressed: () => callback(),
        ),
      )
    );
  }

  _buildActivitiesList() {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Colors.white10,
      ),
      itemCount: groupedActivities.length,
      itemBuilder: (context, index) {
        final Activities ca = groupedActivities[index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(15.0, 11.0, 15.0, 12.0),
              child: Text(format.format(ca.date), style: TextStyles.body(context)),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 13.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIcon('gym', ca.gym),
                  _buildIcon('sport', ca.sport),
                  _buildIcon('running', ca.running),
                  _buildIcon('walking', ca.walking),
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
            Opacity(
              child: Text('${minutes.toString()} min', style: TextStyles.body(context)),
              opacity: 0.7,
            ),
          ],
        ),
      ),
    );
  }
  
  _buildLoadingSpinner() {
    return loading ? LinearProgressIndicator() : SizedBox(height: 6.5);
  }
}
