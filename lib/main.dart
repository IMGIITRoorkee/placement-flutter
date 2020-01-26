import 'package:flutter/material.dart';
import 'package:placement/services/routing/palcement_routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("inside build");
    return MaterialApp(
      title: 'Placement',
      initialRoute: '/',
      onGenerateRoute: RouteGeneratorPlacement.getRoutes,
    );
  }
}
