import 'package:flutter/material.dart';
import 'package:galaxia/screens/onboarding/onboarding_2.dart';

class OnBoarding1 extends StatefulWidget {
  const OnBoarding1({super.key});

  @override
  OnBoarding1State createState() => OnBoarding1State();
}

class OnBoarding1State extends State<OnBoarding1> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const OnBoarding2(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/on_boarding_1.png",
            fit: BoxFit.cover,
          ),
          Positioned(
              bottom: 0,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black
                            .withOpacity(0.8), // Adjust opacity as needed
                        Colors.transparent,
                      ],
                    ),
                  ))),
          Positioned(
            bottom: 46.0,
            left: 32,
            right: 32,
            child: Column(
              children: [
                Text(
                  "Welcome To 👋 Galaxia",
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  "The best E-commerce app of the century for your daily needs!",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
