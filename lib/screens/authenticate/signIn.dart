import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

  final Function toggleview;
  SignIn({this.toggleview});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Sign-in"),
    );
  }
}