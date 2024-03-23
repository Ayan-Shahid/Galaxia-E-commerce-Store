import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/carousal_indicator.dart';
import 'package:galaxia/stacks/authentication.dart';
import 'package:galaxia/theme/theme.dart';

class OnBoarding2 extends StatefulWidget {
  const OnBoarding2({super.key});

  @override
  OnBoarding1State createState() => OnBoarding1State();
}

class OnBoarding1State extends State<OnBoarding2> {
  int current = 0;
  List<String> images = [
    "assets/illustrations/On Boarding 1.svg",
    "assets/illustrations/On Boarding 2.svg",
    "assets/illustrations/On Boarding 3.svg"
  ];
  List<String> text = [
    "We Provide high quality products just for you",
    "Your satisfaction is our number one priority",
    "Let’s fulfil your daily needs with Galaxia right now! "
  ];
  void next() {
    if (current < images.length - 1) {
      setState(() {
        current += 1;
      });
    } else if (current == images.length - 1) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return const Authentication();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: grayscale[200],
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            child: SvgPicture.asset(
              images[current],
              width: width,
            ),
          ),
          Positioned(
            bottom: 32.0,
            left: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                  color: grayscale[100],
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32))),
              child: Column(
                children: [
                  for (int index = 0; index < text.length; index++)
                    Visibility(
                      visible: current == index,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: current == index ? 1.0 : 0.0,
                        child: Text(
                          text[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: width * 0.07,
                              fontWeight: FontWeight.w900,
                              height: 1.6),
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 32,
                  ),
                  CarousalIndicator(
                    current: current,
                    length: 3,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: next,
                      style: ElevatedButton.styleFrom(
                          foregroundColor: primary[900]),
                      child: Text(
                        "Next",
                        style: TextStyle(fontSize: width * 0.032),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
