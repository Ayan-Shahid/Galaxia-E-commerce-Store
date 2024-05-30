import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:galaxia/screens/wallet/top_up_e_wallet.dart';
import 'package:galaxia/theme/theme.dart';
import 'package:intl/intl.dart';

class EWalletCard extends StatefulWidget {
  const EWalletCard({super.key});
  @override
  EWalletCardState createState() => EWalletCardState();
}

class EWalletCardState extends State<EWalletCard> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  num balance = 0;
  getBalance() async {
    try {
      final num data = await firestore
          .collection("E-Wallet")
          .doc(auth.currentUser?.uid)
          .get()
          .then((value) => value.get("Balance"));
      setState(() {
        balance = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBalance();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: width * 0.52,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
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
                    color: secondary[500],
                  ),
                )),
            Positioned(
                top: -MediaQuery.of(context).size.height * 0.14,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.28,
                  width: MediaQuery.of(context).size.height * 0.28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: secondary[300],
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
                    color: secondary[400],
                  ),
                )),
          ],
        ),
        Positioned.fill(
            child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 56, sigmaY: 56),
          child: Container(
            color: secondary[500]?.withOpacity(0.1),
          ),
        )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${auth.currentUser?.displayName}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.06),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "**** **** ****  ****",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.024),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SvgPicture.asset(
                    "assets/icons/Mastercard.svg",
                    width: width * 0.12,
                  )
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                      child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your Balance",
                          style: TextStyle(fontSize: width * 0.032),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          "\$${NumberFormat("#,###").format(balance.toInt())}",
                          style: TextStyle(
                              fontSize: width * 0.09,
                              fontWeight: FontWeight.w900),
                        )
                      ],
                    ),
                  )),
                  const SizedBox(
                    width: 24,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          foregroundColor: primary[900]),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                                builder: (context) => const TopUpEWallet()));
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/Top Up.svg",
                            width: width * 0.04,
                            fit: BoxFit.scaleDown,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Top Up",
                            style: TextStyle(fontSize: width * 0.032),
                          )
                        ],
                      ))
                ],
              )
            ],
          ),
        )
      ]),
    );
  }
}
