import 'package:flutter/material.dart';
import 'package:schedule_management/features/auth/sign_in_view.dart';
import 'package:schedule_management/features/auth/sign_up_view.dart';
import 'package:schedule_management/features/bottom_navigator/bottom_navigator_view.dart';

import 'routes_name.dart';

class Routes {
  static Route<dynamic> routeBuilder(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.signIn:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SignInView(),
        );
      case RoutesName.signUp:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SignUpView(),
        );
      case RoutesName.bottomNavigator:
        return MaterialPageRoute(
          builder: (BuildContext context) => const BottomNavigationView(),
        );
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }
  }

  static void goToSignInScreen(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        RoutesName.signIn, (Route<dynamic> route) => false);
  }

  static void goToSignUpScreen(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        RoutesName.signUp, (Route<dynamic> route) => false);
  }

  static void goToBottomNavigatorScreen(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        RoutesName.bottomNavigator, (Route<dynamic> route) => false);
  }
}
