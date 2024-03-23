import 'package:flutter/material.dart';
import 'package:placement/locator.dart';
import 'package:placement/resources/R.dart';
import 'package:placement/services/routing/placement_routes.dart';
import 'package:placement/themes/theme.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: placementTheme,
      title: 'Placement',
      initialRoute: '/',
      onGenerateRoute: RouteGeneratorPlacement.getRoutes,
      debugShowCheckedModeBanner: false,
    );
  }
}
