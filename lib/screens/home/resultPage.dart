import 'package:flutter/material.dart';
import 'package:placement/resources/strings.dart';
import 'package:placement/screens/home/screen_for_results.dart/resultsBranchWise.dart';
import 'package:placement/screens/home/screen_for_results.dart/resultsCompanyWise.dart';

class ResultPage extends StatefulWidget {
  ResultPage({Key key}) : super(key: key);
  @override
  _ResultPageState createState() => _ResultPageState();
}


class _ResultPageState extends State<ResultPage> with SingleTickerProviderStateMixin {

  TabController _tabController;
  ScrollController _scrollController;
  bool _showBranchWiseResults = true;

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
      text: Strings.RESULT_TABBAR[0],
    ),
    Tab(
      text: Strings.RESULT_TABBAR[1],
    ),
  ]; 

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    int results_for; 
      return NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text(Strings.PLACEMENT_YEAR),
              centerTitle: true,
              pinned: true,
              floating: true,
              forceElevated: boxIsScrolled,
              bottom: _resultsListPage(context),
            )
          ];
        },
        body: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            ResultsBranchWise(),
            ResultsCompanyWise(),
          ],
        ),
      );
  }

  Widget _resultsListPage(BuildContext context) {
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