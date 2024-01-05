import 'package:flutter/cupertino.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Future<dynamic> navigateToWithRemove(
      String routeName, Map<String, dynamic> args) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
        routeName, (Route<dynamic> route) => false,
        arguments: args);
  }

  Future<dynamic> navigateTo(String routeName, Map<String, dynamic> args) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: args);
  }
}
