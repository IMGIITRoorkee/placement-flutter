import 'package:flutter/material.dart';
import 'package:placement/resources/R.dart';

final ThemeData placementTheme = ThemeData(
    useMaterial3: false,
    primaryColor: R.primaryCol,
    appBarTheme: AppBarTheme(backgroundColor: R.primaryCol),
    tabBarTheme: TabBarTheme(
      indicatorColor: R.primaryCol,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white70,
    ));
