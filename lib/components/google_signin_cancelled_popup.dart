import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/popup.dart';

class GoogleSignInCancelledPopUp extends StatelessWidget {
  const GoogleSignInCancelledPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return PopUp(
        borderRadius: 124,
        padding:
            const EdgeInsets.only(top: 32, left: 32, right: 32, bottom: 32),
        content: Column(
          children: [
            SvgPicture.asset(
              "assets/illustrations/400 Error.svg",
              width: MediaQuery.of(context).size.width * 0.6,
            ),
            const SizedBox(
              height: 24,
            ),
            Text("Sign-In Cancelled!",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: 200,
              child: Text(
                "You cancelled Google Sign-In. Please try again or contact support.",
                softWrap: true,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          ],
        ));
  }
}
