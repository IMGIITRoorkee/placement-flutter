import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:placement/resources/R.dart';
import 'package:placement/resources/strings.dart';
import 'package:placement/screens/home/applyPage.dart';
import 'package:placement/screens/home/calendarPage.dart';
import 'package:placement/screens/home/candidatePage.dart';
import 'package:placement/screens/home/resultPage.dart';
import 'package:placement/services/auth/auth_service.dart';
import 'package:placement/views/CandidateDetailsView.dart';
import 'package:placement/views/ResultPageView.dart';
import 'package:placement/views/calendarView.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  TabController _tabController;
  bool _isCollapsed = true;
  AuthService _auth;
  
  final List<Tab> _bottomTab = <Tab>[
      Tab(
        icon: Icon(Icons.check_circle),
        text: 'Apply',
      ),
      Tab(
        icon: Icon(Icons.insert_drive_file),
        text: 'Results',
      ),
      Tab(
        icon: Icon(Icons.perm_contact_calendar),
        text: 'Calendar',
      ),
      Tab(
        icon: Icon(Icons.person),
        text: 'Profile',
      )
  ];

  @override
  void initState() {
    super.initState();
    _auth = AuthService();
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

  void _onHorizontalDrag(DragEndDetails details) {
    if(details.primaryVelocity == 0) return; // user have just tapped on screen (no dragging)

    if (details.primaryVelocity.compareTo(0) == -1)
      setState(() {
        _isCollapsed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    double _height = _size.height;
    double _width = _size.width;
    return _homePageStack(context, _height, _width);
  }

  Widget _homePageStack(BuildContext context, double _height, double _width) {
    return Stack(
      children: <Widget>[
        _homePageScaffold(context),
        /// Notifications and Hamburger Menu
        /// F
        // SafeArea(
        //   child: Align(
        //     alignment: Alignment.topRight,
        //     child: Container(
        //       child: GestureDetector(
        //         onTap: () {
        //           print("tapped!!");
        //         },
        //         child: Padding(
        //           padding: EdgeInsets.fromLTRB(0.0, 10.0, 10, 0.0),
        //           child: Material(
        //             color: Colors.transparent,
        //             child: IconButton(
        //               icon: Icon(
        //                 Icons.notifications,
        //                 size: 30,
        //                 color: Colors.white,
        //               ),
        //               onPressed: () {
        //                 Navigator.of(context).pushNamed('/notifs');
        //               },
        //             )
        //           )  
        //         ),
        //       )
        //     ),
        //   )
        // ),
        // SafeArea(
        //   child: Align(
        //     alignment: Alignment.topLeft,
        //     child: Container(
        //       child: GestureDetector(
        //         onTap: () {
        //           print("tapped!!");
        //         },
        //         child: Padding(
        //           padding: EdgeInsets.fromLTRB(0.0, 10.0, 10, 0.0),
        //           child: Material(
        //             color: Colors.transparent,
        //             child: IconButton(
        //               icon: Icon(
        //                 Icons.menu,
        //                 size: 30,
        //                 color: Colors.white,
        //               ),
        //               onPressed: () {
        //                 setState(() {
        //                   _isCollapsed = false;
        //                 });
        //               },
        //             )
        //           )  
        //         ),
        //       )
        //     ),
        //   )
        // ),
        // Container(
        //   child: BackdropFilter(
        //     filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        //     child: Container(
        //       height: _isCollapsed ? 0 : _height,
        //       width:  _isCollapsed ? 0 : _width,
        //       decoration: BoxDecoration(
        //         color: Colors.grey.shade200.withOpacity(0.05)
        //       ),
        //     ),
        //   ),
        // ),
        // Positioned(
        //   left: 0,
        //   child: GestureDetector(
        //     onHorizontalDragEnd: (DragEndDetails details) => _onHorizontalDrag(details),
        //     child: AnimatedContainer(
        //       duration: Duration(milliseconds: 300),
        //       height: _height,
        //       width: _isCollapsed ? 0 : _width*0.75,
        //       child: _isCollapsed ? Container() :
        //       Material(
        //         elevation: 8.0,
        //         child: Scaffold(
        //           appBar: AppBar(
        //             elevation: 0.0,
        //             actions: <Widget>[
        //               IconButton(
        //                 icon: Icon(Icons.arrow_back_ios),
        //                 onPressed: () {
        //                   setState(() {
        //                     _isCollapsed = true;
        //                   });
        //                 },
        //               )
        //             ],
        //           ),
        //           body: Container(
        //             child: LayoutBuilder(
        //               builder: (context, constraints) {
        //                 if (constraints.maxWidth < 50) {
        //                   return Container();
        //                 } else {
        //                   return menu(context, _height, _width);
        //                 }
        //               },
        //             )
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _homePageScaffold(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: _tabSelector(),
      ),
      bottomNavigationBar: 
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10.0,
              spreadRadius: 2.0,
              offset: Offset(0,-5),
            ),
          ]
        ),
        child: TabBar(
          controller: _tabController,
          tabs: _bottomTab,
          indicatorPadding: EdgeInsets.all(5.0),
          indicatorColor: R.primaryCol,
          labelColor: R.primaryCol,
          unselectedLabelColor: Colors.grey,
        )
      )
    );
  }

  List<Widget> _tabSelector() {
    return <Widget>[
      Container(
        child: ApplyPage()
      ),
      Container(
        child: ResultPageView()
      ),
      Container(
        child: CalendarView()
      ),
      Container(
        child: CandidateDetailsView()
      ),
    ];
  }

  Widget menu(BuildContext context, double _height, double _width) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            color: Colors.blue,
            height: 200,
            child: Center(
              child: Icon(
                Icons.arrow_drop_down_circle,
                size: 40,  
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(10, 5, 5, 5),
            leading: Icon(Icons.format_list_bulleted),
            title: Text("Resume list"),
            onTap: () {
              
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(10, 5, 5, 5),
            leading: Icon(Icons.help_outline),
            title: Text("FAQs"),
            onTap: () {
              
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(10, 5, 5, 5),
            leading: Icon(Icons.info),
            title: Text("About Us"),
            onTap: () {
              
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(10, 5, 5, 5),
            leading: Icon(Icons.exit_to_app),
            title: Text("Log Out"),
            onTap: () async {
              await _auth.logOut();
              Navigator.of(context).pushNamedAndRemoveUntil('/wrapper',(Route<dynamic> route)=>false);
            },
          ),
        ],
      ),
    );
  }
}