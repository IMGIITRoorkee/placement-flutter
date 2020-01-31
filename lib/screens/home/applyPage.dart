import 'package:flutter/material.dart';
import 'package:placement/resources/strings.dart';

class ApplyPage extends StatefulWidget {
  ApplyPage({Key key}) : super(key: key);
  @override
  _ApplyPageState createState() => _ApplyPageState();
}


class _ApplyPageState extends State<ApplyPage> with SingleTickerProviderStateMixin {

  TabController _tabController;

    @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 2
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Tab> _profileTabs = <Tab>[
    Tab(
      text: Strings.APPLY_TABBAR[0],
    ),
    Tab(
      text: Strings.APPLY_TABBAR[1],
    ),
  ]; 

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(Strings.HOME_APPBAR),
        centerTitle: true,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          child: _profilesListPage(context),
          color: Colors.blue,
        )
      )
    );
  }

  Widget _profilesListPage(BuildContext context) {
    return TabBar(
      controller: _tabController,
      tabs: _profileTabs,
      unselectedLabelColor: Colors.white70,
      indicatorPadding: EdgeInsets.only(top: 10),
      indicatorColor: Colors.white,
      indicatorWeight: 6.0,
    );
  }
}