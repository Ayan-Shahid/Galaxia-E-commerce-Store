import 'package:flutter/material.dart';
import 'package:galaxia/navigator_keys.dart';
import 'package:galaxia/screens/wallet/confirm_top_up.dart';

import 'package:galaxia/screens/wallet/home.dart';
import 'package:galaxia/screens/wallet/select_top_up_method.dart';
import 'package:galaxia/screens/wallet/top_up_e_wallet.dart';

class Wallet extends StatelessWidget {
  const Wallet({super.key});
  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      '/': (context) => const Home(),
      "/select top up method": (context) => const SelectTopUpMethod(
            amount: 0,
          ),
      "/top up wallet": (context) => const TopUpEWallet(),
      '/confirm top up': (context) => const ConfirmTopUp(
            amount: 0,
          )
    };
  }

  @override
  Widget build(BuildContext context) {
    Map<String, WidgetBuilder> routeBuilders = _routeBuilders(context);
    return Navigator(
      initialRoute: '/',
      key: NavigatorKeys.walletScreenNavigatorKey,
      onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => routeBuilders[settings.name]!(context)),
    );
  }
}
