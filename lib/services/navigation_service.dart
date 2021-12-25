import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> pushNamed(
    String routeName, {
    Map<String, dynamic> arguments = const {},
  }) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacement(
    String routeName, {
    Map<String, dynamic> arguments = const {},
  }) {
    return navigatorKey.currentState!.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<dynamic> removeAllAndPush(
    String routeName, {
    Map<String, dynamic> arguments = const {},
  }) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  Future<dynamic> popUntil(
    String routeName, {
    Map<String, dynamic> arguments = const {},
  }) async {
    navigatorKey.currentState!.popUntil((currentRoute) => currentRoute.settings.name == routeName);
  }

  void pop({bool resetColor = true}) {
    return navigatorKey.currentState!.pop();
  }
}
