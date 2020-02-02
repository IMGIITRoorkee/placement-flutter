import 'package:flutter/material.dart';

class ResultDetailsCompanyWise extends StatefulWidget {
  final Map<String, String> args;
  ResultDetailsCompanyWise({Key key, this.args}) : super(key: key);

  @override
  _ResultDetailsCompanyWiseState createState() => _ResultDetailsCompanyWiseState();
}

class _ResultDetailsCompanyWiseState extends State<ResultDetailsCompanyWise> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         appBar: AppBar(
           title: Text("Branch"),
         ),
       ),
    );
  }
}