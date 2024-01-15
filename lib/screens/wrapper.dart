import 'package:flutter/material.dart';
import 'package:placement/screens/authenticate/authenticatePage.dart';
import 'package:placement/screens/home/homePage.dart';
import 'package:placement/shared/dataProvider.dart';
import 'package:placement/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class WrapperPage extends StatefulWidget {
  WrapperPage({Key? key}) : super(key: key);

  @override
  _WrapperPageState createState() => _WrapperPageState();
}

class _WrapperPageState extends State<WrapperPage> {
  late AuthService _auth;
  late DataProvider data;
  final Duration _duration = Duration(milliseconds: 300);
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _auth = AuthService();
    data = DataProvider();
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    double _height = _size.height;
    double _width = _size.width;
    //return _auth.authStateListener() ? HomePage() : Authenticate();
    return ChangeNotifierProvider(
        create: (context) => DataProvider(),
        child: _auth.authStateListener() ? HomePage() : Authenticate());
    // return Scaffold(
    //   //
    //   appBar: AppBar(
    //     title: Text("test"),
    //   ),
    //   drawer: Drawer(
    //     elevation: 8.0,
    //     child: menu(context, _height, _width),
    //   ),
    //   body: Container(
    //     color: Colors.red,
    //     height: 200,
    //     width: 200,
    //   ),
    // );
  }

  Widget dashboard(BuildContext context, double _height, double _width) {
    // return Container(
    //   child: AnimatedPositioned(
    //     top: _isCollapsed ? 0 : 0.2*_height,
    //     bottom: _isCollapsed ? 0 : 0.2*_height,
    //     right: _isCollapsed ? 0 : -0.1*_width,
    //     left: _isCollapsed ? 0 : 0.5*_width,
    //     duration: _duration,
    //     // child: _auth.authStateListener() ? HomePage() : Authenticate(),
    //     child: Material(
    //       animationDuration: _duration,
    //       borderRadius: BorderRadius.all(Radius.circular(40.0)),
    //       elevation: 8.0,
    //       child: Scaffold(
    //         appBar: AppBar(title: Text("test"),),
    //         body: Container(
    //           color: Colors.red,
    //           width: 200,
    //           height: 200,
    //         ),
    //       )
    //     ),
    //   ),
    // );
    return Container(
      child: AnimatedPositioned(
          duration: _duration,
          // top: _isCollapsed ? 0 : 0.2*_height,
          // bottom: _isCollapsed ? 0 : 0.2*_height,
          // right: _isCollapsed ? 0 : -0.1*_width,
          // left: _isCollapsed ? 0 : 0.5*_width,
          child: Material(
            animationDuration: _duration,
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            elevation: 8.0,
            child: Container(
              color: Colors.red,
              child: Scaffold(
                appBar: AppBar(
                  title: Text("test"),
                ),
                body: Container(
                  color: Colors.blue,
                  height: 200,
                  width: 200,
                ),
              ),
            ),
          )),
    );
  }
}
