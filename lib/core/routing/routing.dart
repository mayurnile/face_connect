import 'package:flutter/material.dart';

import './route_names.dart';
import './routing_animations.dart';

import '../../presentation/screens.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.defaultRoute:
      return getHorizontalSlideRoute(const LoginScreen(), settings);
    case AppRoutes.loginRoute:
      return getHorizontalSlideRoute(const LoginScreen(), settings);
    case AppRoutes.verifyOTPRoute:
      final Map<String, dynamic>? args = settings.arguments as Map<String, dynamic>?;

      bool isSignup = false;
      if (args != null && args['is_signup'] != null) isSignup = args['is_signup'] as bool;

      return getHorizontalSlideRoute(
        VerifyOTPScreen(isSignup: isSignup),
        settings,
      );
    case AppRoutes.signupRoute:
      return getHorizontalSlideRoute(const SignupScreen(), settings);
    case AppRoutes.userVerificationRoute:
      return getHorizontalSlideRoute(const UserVerificationScreen(), settings);
    case AppRoutes.getStartedRoute:
      return getHorizontalSlideRoute(const GetStartedScreen(), settings);
    case AppRoutes.landingRoute:
      return getHorizontalSlideRoute(const LandingScreen(), settings);
    default:
      return getHorizontalSlideRoute(const SplashScreen(), settings);
  }
}
