import 'package:flutter/material.dart';
import 'dart:async';

import 'package:placement/resources/strings.dart';
import 'package:placement/services/api_models/fetchService.dart';
import 'package:placement/services/auth/auth_service.dart';
import 'package:placement/shared/loadingPage.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late AuthService _auth;

  @override
  void initState() {
    super.initState();
    _auth = AuthService();
    Timer(Duration(seconds: 2), () {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/wrapper', (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Material(
        child: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
        ),
        Column(
          children: <Widget>[
            Expanded(
              flex: 6,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 115,
                      width: 100,
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Image.asset("assets/applogoaspect.png"),
                    ),
                    Text(
                      Strings.PLACEMENT,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 24.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    LoadingPage(),
                  ],
                )),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Made With ",
                        style: TextStyle(
                          color: Colors.blueAccent,
                        ),
                      ),
                      Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      Text(
                        " by IMG",
                        style: TextStyle(
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    ));
  }
}
