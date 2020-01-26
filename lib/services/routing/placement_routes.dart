import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:placement/screens/splash/splash.dart';
import 'package:placement/screens/wrapper.dart';

class RouteGeneratorPlacement {
  static Route<dynamic> getRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => SplashPage()
        );
        break;
      case '/wrapper':
      return MaterialPageRoute(
        builder: (_) => WrapperPage()
      );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: Text('Error'),
            ),
            body: Center(
              child: Text('Error has occurred'),
            ),
          )
        );
    }
  }
}