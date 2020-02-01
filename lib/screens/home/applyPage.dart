import 'package:flutter/material.dart';
import 'package:placement/resources/strings.dart';
import 'package:placement/screens/home/screens_for_apply/profilesForAllScreen.dart';
import 'package:placement/screens/home/screens_for_apply/profilesForMeScreen.dart';
import 'package:placement/services/api_models/fetchService.dart';

class ApplyPage extends StatefulWidget {
  ApplyPage({Key key}) : super(key: key);
  @override
  _ApplyPageState createState() => _ApplyPageState();
}


class _ApplyPageState extends State<ApplyPage> with SingleTickerProviderStateMixin {

  TabController _tabController;
  bool _showProfilesForMe = true;

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
        title: Text(Strings.APPLY_APPBAR),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              child: _profilesListPage(context),
              color: Colors.blue,
            )
          ),
          Container(
            child: _tabSelector(context),
          )
        ],
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
      onTap: (index) {
        switch (index) {
          case 0 :
            setState(() {
              _showProfilesForMe = true;
            });
            break;
          case 1 :
            setState(() {
              _showProfilesForMe = false;
            });
            break;
          default:
        }
      },
    );
  }

  Widget _tabSelector(BuildContext context) {
    return _showProfilesForMe ? ProfilesForMePage() : ProfilesForAllPage();
  }
}