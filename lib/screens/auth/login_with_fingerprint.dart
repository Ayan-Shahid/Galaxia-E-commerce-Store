import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/theme/theme.dart';
import 'package:rive/rive.dart';

class LoginWithFingerprint extends StatefulWidget {
  const LoginWithFingerprint({Key? key}) : super(key: key);

  @override
  LoginWithFingerprintState createState() => LoginWithFingerprintState();
}

class LoginWithFingerprintState extends State<LoginWithFingerprint> {
  late Artboard _artboard;
  late RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();

    _loadRiveFile();
  }

  void _loadRiveFile() async {
    // Load the Rive file
    final ByteData data = await rootBundle.load('assets/fingerprint.riv');
    final RiveFile file = RiveFile.import(data);

    // Get the default artboard
    final Artboard artboard = file.mainArtboard;

    // Set the artboard to the state
    setState(() {
      _artboard = artboard;
      _controller = SimpleAnimation('idle', autoplay: false);
      _artboard.addController(_controller);
    });
  }

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
                "Login With Fingerprint",
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
        padding:
            const EdgeInsets.only(left: 24, right: 24, top: 72, bottom: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Use your fingerprint to login.",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 32,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              child: RiveAnimation.asset(
                "assets/rive/fingerprint.riv",
                fit: BoxFit.cover,
                controllers: [SimpleAnimation("idle", autoplay: false)],
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Text(
              "Please put your finger on the fingerprint scanner to get started.",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: grayscale[200],
                            foregroundColor: grayscale[600],
                            padding: const EdgeInsets.symmetric(vertical: 20)),
                        onPressed: () {},
                        child: Text(
                          "Skip",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: grayscale[1000]),
                        ))),
                const SizedBox(
                  width: 24,
                ),
                Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 20)),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext popupcontext) {
                                return Stack(
                                  children: [
                                    BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 2, sigmaY: 2),
                                        child: Container(
                                          color: primary[100]?.withOpacity(0.6),
                                        )),
                                    AlertDialog(
                                      backgroundColor: grayscale[100],
                                      surfaceTintColor: grayscale[100],
                                      content: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.44,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/illustrations/Sign Up Success.svg",
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.48,
                                              ),
                                              const SizedBox(
                                                height: 32,
                                              ),
                                              Text(
                                                "Congratulations!",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 24,
                                              ),
                                              Text(
                                                "Your account is ready to use. You will be redirected to the Home page in a few seconds.",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(
                                                height: 32,
                                              ),
                                              SvgPicture.asset(
                                                  "assets/illustrations/Spinner.svg")
                                            ]),
                                      ),
                                      shape: ContinuousRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(156),
                                          side: BorderSide(
                                              color: grayscale[400] ??
                                                  Colors.black38)),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Text(
                          "Continue",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: primary[900]),
                        ))),
              ],
            )
          ],
        ),
      )),
    );
  }
}
