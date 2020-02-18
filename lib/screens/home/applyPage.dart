import 'package:flutter/material.dart';
import 'package:placement/resources/strings.dart';
import 'package:placement/screens/home/screens_for_apply/profilesForAllScreen.dart';
import 'package:placement/screens/home/screens_for_apply/profilesForMeScreen.dart';

class ApplyPage extends StatefulWidget {
  ApplyPage({Key key}) : super(key: key);
  @override
  _ApplyPageState createState() => _ApplyPageState();
}


class _ApplyPageState extends State<ApplyPage> with SingleTickerProviderStateMixin {

  TabController _tabController;
  ScrollController _scrollController;

    @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 2
    );
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
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
    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            title: Text(Strings.APPLY_APPBAR),
            centerTitle: true,
            pinned: true,
            floating: true,
            forceElevated: boxIsScrolled,
            bottom: _profilesListPage(context),
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          ProfilesForMePage(),
          ProfilesForAllPage()
        ],
      ),
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
      onTap: (index) {
        
      },
    );
  }
}