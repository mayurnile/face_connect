import 'package:flutter/material.dart';

import './route_names.dart';

PageRoute getHorizontalSlideRoute(Widget child, RouteSettings settings) {
  return _HorizontalSlideRoute(child: child, routeName: settings.name ?? AppRoutes.defaultRoute);
}

PageRoute getSlideRoute(Widget child, RouteSettings settings) {
  return _SlideRoute(child: child, routeName: settings.name ?? AppRoutes.defaultRoute);
}

class _HorizontalSlideRoute extends PageRouteBuilder {
  final Widget child;
  final String routeName;

  _HorizontalSlideRoute({required this.child, required this.routeName})
      : super(
          settings: RouteSettings(name: routeName),
          barrierColor: Colors.transparent,
          barrierDismissible: false,
          fullscreenDialog: false,
          opaque: false,
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              child,
          transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
            const curve = Curves.easeInOutCubic;
            final curveTween = CurveTween(curve: curve);

            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end).chain(curveTween);
            final offsetAnimation = animation.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}

class _SlideRoute extends PageRouteBuilder {
  final Widget child;
  final String routeName;

  _SlideRoute({required this.child, required this.routeName})
      : super(
          settings: RouteSettings(name: routeName),
          barrierColor: Colors.transparent,
          barrierDismissible: false,
          fullscreenDialog: false,
          opaque: false,
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              child,
          transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
            const curve = Curves.easeInOutCubic;
            final curveTween = CurveTween(curve: curve);

            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end).chain(curveTween);
            final offsetAnimation = animation.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}
