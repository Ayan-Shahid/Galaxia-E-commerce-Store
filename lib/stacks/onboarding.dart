import 'package:flutter/material.dart';
import 'package:galaxia/navigator_keys.dart';
import 'package:galaxia/screens/onboarding/onboarding_1.dart';
import 'package:galaxia/screens/onboarding/onboarding_2.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});
  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      '/': (context) => const OnBoarding1(),
      "/next": (context) => const OnBoarding2(),
    };
  }

  @override
  Widget build(BuildContext context) {
    Map<String, WidgetBuilder> routeBuilders = _routeBuilders(context);

    return Navigator(
      key: NavigatorKeys.onBoardingScreenNavigatorKey,
      initialRoute: '/',
      onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => routeBuilders[settings.name]!(context)),
    );
  }
}
