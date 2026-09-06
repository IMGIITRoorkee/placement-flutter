import 'package:flutter/material.dart';

import 'locator.dart';
import 'resources/R.dart';
import 'services/routing/placement_routes.dart';
import 'services/routing/navigationService.dart';
import 'services/auth/auth_service.dart';

void main() async {
  // TODO: Look for more consistent method that prevent race condition when phone is sleeping
  setupLocator();
  await AuthService().initState();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      AuthService().refreshToken();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: locator<NavigationService>().navigatorKey,
      theme: Theme.of(context).copyWith(
        primaryColor: R.primaryCol,
        appBarTheme: AppBarTheme(
          backgroundColor: R.primaryCol, 
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: R.primaryCol,
          foregroundColor: Colors.white,
        ),
        radioTheme: RadioThemeData(
          fillColor: WidgetStateColor.resolveWith((states) => R.textColSecondary),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: R.textColSecondary
          )
        )
      ),
      title: 'Placement',
      initialRoute: '/',
      onGenerateRoute: RouteGeneratorPlacement.getRoutes,
      debugShowCheckedModeBanner: false,
    );
  }
}
