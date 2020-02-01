import 'package:flutter/material.dart';
import 'package:placement/screens/authenticate/authenticatePage.dart';
import 'package:placement/screens/home/homePage.dart';
import 'package:placement/services/auth/auth_service.dart';

class WrapperPage extends StatefulWidget {
  WrapperPage({Key key}) : super(key: key);

  @override
  _WrapperPageState createState() => _WrapperPageState();
}

class _WrapperPageState extends State<WrapperPage> {

  AuthService _auth;

  @override
  void initState() {
    super.initState();
    _auth = AuthService();
  }

  @override
  Widget build(BuildContext context) {
    return _auth.authStateListener() ? HomePage() : Authenticate();
    //return Authenticate();
  }
}