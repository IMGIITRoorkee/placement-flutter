import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final args;
  ProfilePage({Key key, this.args}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Company Details"),
      ),
      body: Container(
        width: _width,
        height: _height,
        color: Colors.red,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 5,),
              Container(
                color: Colors.blue,
                height: 200,
                width: 200,
              ),
              SizedBox(height: 5,),
              Container(
                color: Colors.blue,
                height: 200,
                width: 200,
              ),
              SizedBox(height: 5,),
              Container(
                color: Colors.blue,
                height: 200,
                width: 200,
              ),
              SizedBox(height: 5,),
              Container(
                color: Colors.blue,
                height: 200,
                width: 200,
              ),
              SizedBox(height: 5,),
              Container(
                color: Colors.blue,
                height: 200,
                width: 200,
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}