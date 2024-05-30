import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/popup.dart';

class GoogleSignInNetworkErrorPopUp extends StatelessWidget {
  const GoogleSignInNetworkErrorPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return PopUp(
        borderRadius: 124,
        padding:
            const EdgeInsets.only(top: 32, left: 32, right: 32, bottom: 32),
        content: Column(
          children: [
            SvgPicture.asset(
              "assets/illustrations/404 Error.svg",
              width: MediaQuery.of(context).size.width * 0.6,
            ),
            const SizedBox(
              height: 24,
            ),
            Text("Network Error!",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 16,
            ),
            Text(
              "There was a network error. Please check your internet connection and try again!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ));
  }
}
