import 'package:flutter/material.dart';
import 'package:placement/screens/authenticate/signIn.dart';
import 'package:placement/screens/authenticate/signUp.dart';

class Authenticate extends StatefulWidget {
  Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool sign_in_shown = true;
  void toggle() {
    setState(() => sign_in_shown = !sign_in_shown);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: sign_in_shown
          ? SignIn(toggleview: toggle)
          : Register(toggleView: toggle),
    );
  }
}
