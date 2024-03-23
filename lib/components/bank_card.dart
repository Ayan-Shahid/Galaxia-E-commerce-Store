import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/theme/theme.dart';

class BankCard extends StatelessWidget {
  const BankCard({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: width * 0.5,
      width: MediaQuery.of(context).size.width,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(108),
            side: BorderSide(color: grayscale[400]!)),
      ),
      child: Stack(children: [
        Stack(
          children: [
            Positioned(
                bottom: -MediaQuery.of(context).size.height * 0.18,
                left: -MediaQuery.of(context).size.height * 0.04,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.24,
                  width: MediaQuery.of(context).size.height * 0.24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: grayscale[500],
                  ),
                )),
            Positioned(
                top: -MediaQuery.of(context).size.height * 0.14,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.28,
                  width: MediaQuery.of(context).size.height * 0.28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: grayscale[500],
                  ),
                )),
            Positioned(
                bottom: -MediaQuery.of(context).size.height * 0.02,
                right: -MediaQuery.of(context).size.height * 0.04,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: grayscale[500],
                  ),
                )),
          ],
        ),
        Positioned.fill(
            child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 56, sigmaY: 56),
          child: Container(
            color: grayscale[400]?.withOpacity(0.1),
          ),
        )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Card Name",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SvgPicture.asset(
                    "assets/icons/Visa.svg",
                    width: 72,
                  )
                ],
              ),
              Text(
                "**** **** ****  ****",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Card Holder Name",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.024),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Ayan Shahid",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.024),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Expiry Date",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.024),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "12/4/2022",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.024),
                      )
                    ],
                  ),
                  SvgPicture.asset(
                    "assets/icons/Mastercard.svg",
                    width: 56,
                  )
                ],
              )
            ],
          ),
        )
      ]),
    );
  }
}
