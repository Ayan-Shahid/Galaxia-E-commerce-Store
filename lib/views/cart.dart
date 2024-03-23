import 'package:flutter/material.dart';
import 'package:galaxia/navigator_keys.dart';
import 'package:galaxia/screens/cart/check_out.dart';
import 'package:galaxia/screens/cart/choose_payment_method.dart';
import 'package:galaxia/screens/cart/choose_shipping_mode.dart';

import 'package:galaxia/screens/cart/home.dart';
import 'package:galaxia/screens/cart/track_order.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});
  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      '/': (context) => const Home(),
      "/check out": (context) => const CheckOut(),
      "/choose shipping mode": (context) => const ChooseShippingMode(
            total: 0,
          ),
      "/choose payment method": (context) => const ChoosePaymentMethod(
            amount: 0,
          ),
      '/track order': (context) => const TrackOrder()
    };
  }

  @override
  Widget build(BuildContext context) {
    Map<String, WidgetBuilder> routeBuilders = _routeBuilders(context);
    return Navigator(
      initialRoute: '/',
      key: NavigatorKeys.cartScreenNavigatorKey,
      onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => routeBuilders[settings.name]!(context)),
    );
  }
}
