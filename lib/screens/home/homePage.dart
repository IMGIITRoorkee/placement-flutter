import 'package:flutter/material.dart';
import 'package:placement/resources/strings.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  TabController _tabController;
  dynamic a;
  
  final List<Tab> _bottomTab = <Tab>[
      Tab(
        icon: Icon(Icons.access_alarm),
      ),
      Tab(
        icon: Icon(Icons.account_box),
      ),
      Tab(
        icon: Icon(Icons.add_circle),
      ),
      Tab(
        icon: Icon(Icons.add_alert),
      ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 4
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              print("Notified!!");
            },
          ),
        ],
        title: Text(Strings.HOME_APPBAR),
        centerTitle: true,
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabSelector(),
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: _bottomTab,
        indicatorPadding: EdgeInsets.all(5.0),
        labelColor: Colors.red,
      ),
    );
  }

  _tabSelector() {
    return <Widget>[
      Container(
        child: Text("Under Construction")
      ),
      Container(
        child: Text("Under Construction")
      ),
      Container(
        child: Text("Under Construction")
      ),
      Container(
        child: Text("Under Construction")
      ),
    ];
  }
}