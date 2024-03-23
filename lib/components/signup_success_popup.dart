import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/popup.dart';

class SignUpSuccessPopUp extends StatelessWidget {
  const SignUpSuccessPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return PopUp(
        borderRadius: 124,
        padding: const EdgeInsets.only(top: 32, left: 32, right: 32, bottom: 32),
        content: Column(
          children: [
            SvgPicture.asset(
              "assets/illustrations/Sign Up Success.svg",
              width: MediaQuery.of(context).size.width * 0.6,
            ),
            const SizedBox(
              height: 24,
            ),
            Text("Congratulations!",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text(
                "Your account is ready to use. You will be redirected to the Home page in a few seconds.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            SvgPicture.asset("assets/illustrations/Spinner.svg")
          ],
        ));
  }
}
