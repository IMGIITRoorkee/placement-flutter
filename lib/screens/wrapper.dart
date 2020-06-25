import 'package:flutter/material.dart';
import 'package:placement/screens/authenticate/authenticatePage.dart';
import 'package:placement/screens/home/homePage.dart';
import 'package:placement/shared/dataProvider.dart';
import 'package:placement/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class WrapperPage extends StatefulWidget {
  WrapperPage({Key key}) : super(key: key);

  @override
  _WrapperPageState createState() => _WrapperPageState();
}

class _WrapperPageState extends State<WrapperPage> {

  AuthService _auth;
  DataProvider data;
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
    return ChangeNotifierProvider(
      create: (context) => data,
      child: _auth.authStateListener() ? HomePage() : Authenticate()
    );
  }
}