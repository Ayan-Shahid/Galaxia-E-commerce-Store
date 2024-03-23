import 'package:flutter/material.dart';
import 'package:galaxia/navigator_keys.dart';
import 'package:galaxia/screens/auth/forgot_password.dart';
import 'package:galaxia/screens/auth/get_started.dart';
import 'package:galaxia/screens/auth/login.dart';
import 'package:galaxia/screens/auth/profile_setup.dart';
import 'package:galaxia/screens/auth/register.dart';

class Authentication extends StatelessWidget {
  const Authentication({super.key});

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      '/': (context) => GetStarted(),
      "/register": (context) => const Register(),
      '/login': (context) => const Login(),
      '/setup profile': (context) => const ProfileSetUp(),
      '/forgot password': (context) => const ForgotPassword(),
    };
  }

  @override
  Widget build(BuildContext context) {
    Map<String, WidgetBuilder> routeBuilders = _routeBuilders(context);

    return Navigator(
      key: NavigatorKeys.authScreenNavigatorKey,
      initialRoute: '/',
      onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => routeBuilders[settings.name]!(context)),
    );
  }
}
