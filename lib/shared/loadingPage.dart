import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:placement/resources/R.dart';

class LoadingPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: SpinKitChasingDots(
          color: R.textColSecondary,
          size: 50.0,
        )
      ),
    );
  }
}