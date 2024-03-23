import 'package:flutter/material.dart';
import 'package:galaxia/navigator_keys.dart';
import 'package:galaxia/screens/profile/add_new_address.dart';
import 'package:galaxia/screens/profile/address.dart';
import 'package:galaxia/screens/profile/home.dart';
import 'package:galaxia/screens/profile/payment.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});
  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      '/': (context) => const Home(),
      "/payment": (context) => const Payment(),
      "/address": (context) => const Address(),
      "/add new address": (context) => const AddNewAddress(),
    };
  }

  @override
  Widget build(BuildContext context) {
    Map<String, WidgetBuilder> routeBuilders = _routeBuilders(context);
    return Navigator(
      key: NavigatorKeys.profileScreenNavigatorKey,
      initialRoute: '/',
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (context) => routeBuilders[settings.name]!(context),
      ),
    );
  }
}
