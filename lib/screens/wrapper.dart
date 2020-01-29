import 'package:flutter/material.dart';
import 'package:placement/screens/authenticate/authenticatePage.dart';
import 'package:placement/screens/home/homePage.dart';
import 'package:provider/provider.dart';
import 'package:placement/models/user.dart';

class WrapperPage extends StatelessWidget {
  const WrapperPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final user = Provider.of<User>(context);
    //return user ==null ? Authenticate() : HomePage();
    return Authenticate();
  }
}