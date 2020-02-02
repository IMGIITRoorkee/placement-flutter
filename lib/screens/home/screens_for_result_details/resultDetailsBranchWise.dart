import 'package:flutter/material.dart';

class ResultDetailsBranchWise extends StatefulWidget {
  ResultDetailsBranchWise({Key key}) : super(key: key);

  @override
  _ResultDetailsBranchWiseState createState() => _ResultDetailsBranchWiseState();
}

class _ResultDetailsBranchWiseState extends State<ResultDetailsBranchWise> {
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