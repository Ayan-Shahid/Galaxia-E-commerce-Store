import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginWithPin extends StatefulWidget {
  const LoginWithPin({Key? key}) : super(key: key);

  @override
  LoginWithPinState createState() => LoginWithPinState();
}

class LoginWithPinState extends State<LoginWithPin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: AppBar(
              centerTitle: false,
              title: Text(
                "Login With Pin",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    "assets/icons/Left Arrow.svg",
                    width: 32,
                    height: 32,
                  )),
            ),
          )),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Enter your PIN to login.",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 75,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: TextFormField(
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(counterText: ""),
                  ),
                ),
                Container(
                  width: 75,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: TextFormField(
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(counterText: ""),
                  ),
                ),
                Container(
                  width: 75,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: TextFormField(
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(counterText: ""),
                  ),
                ),
                Container(
                  width: 75,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: TextFormField(
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(counterText: ""),
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
