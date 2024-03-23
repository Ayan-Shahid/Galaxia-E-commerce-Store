import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/payment_card.dart';
import 'package:galaxia/screens/add_new_bank_card.dart';
import 'package:galaxia/store/app_state.dart';

import 'package:galaxia/theme/theme.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  PaymentState createState() => PaymentState();
}

class PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(width * 0.2),
          child: Container(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
            child: AppBar(
              flexibleSpace: Container(color: grayscale[100]),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    "assets/icons/Dots Horizontal.svg",
                  ),
                ),
              ],
              centerTitle: false,
              leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: SvgPicture.asset(
                    "assets/icons/Left Arrow.svg",
                    width: width * 0.08,
                  )),
              title: Text(
                "Payment",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: width * 0.05),
              ),
            ),
          )),
      body:
          StoreBuilder<AppState>(builder: (galaxiastorecontext, galaxiastore) {
        return SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: galaxiastore.state.paymentMethods.items.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/illustrations/No Data.svg",
                              width: width * 0.8,
                            ),
                            SizedBox(
                              width: width * 0.6,
                              child: Text("You have no payment methods!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: width * 0.05)),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            SizedBox(
                              width: width * 0.6,
                              child: Text(
                                  "You don't have any payment methods saved!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: width * 0.028)),
                            ),
                          ],
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) => Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            child: PaymentCard(
                              icon: galaxiastore
                                  .state.paymentMethods.items[index].type!,
                              method: galaxiastore
                                  .state.paymentMethods.items[index],
                            ),
                          ),
                          itemCount:
                              galaxiastore.state.paymentMethods.items.length,
                        ),
                ),
              ),
              Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32)),
                      border: Border(top: BorderSide(color: grayscale[200]!))),
                  width: width,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AddNewBankCard()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/Plus.svg",
                            width: 16,
                            height: 16,
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Text(
                            "Add New Card",
                            style: TextStyle(color: primary[900]),
                          )
                        ],
                      )))
            ],
          ),
        );
      }),
    );
  }
}
