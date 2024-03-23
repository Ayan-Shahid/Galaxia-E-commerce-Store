import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/popup.dart';

import 'package:galaxia/screens/cart/e_reciept.dart';

import 'package:galaxia/store/galaxia_product.dart';
import 'package:galaxia/theme/theme.dart';

class OrderSuccessfulPopup extends StatelessWidget {
  final List<GalaxiaCartProduct> item;
  final String paymentMethod;
  final DateTime date;
  final String transactionId;
  final num amount;
  const OrderSuccessfulPopup(
      {Key? key,
      required this.item,
      required this.amount,
      required this.date,
      required this.paymentMethod,
      required this.transactionId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return PopUp(
        borderRadius: 124,
        padding:
            const EdgeInsets.only(top: 32, left: 32, right: 32, bottom: 32),
        content: Column(
          children: [
            SvgPicture.asset(
              "assets/illustrations/Order Successful.svg",
              width: MediaQuery.of(context).size.width * 0.44,
            ),
            const SizedBox(
              height: 24,
            ),
            Text("Order Successful!",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              width: width * 0.6,
              child: Text(
                "Your order was successfully placed",
                textAlign: TextAlign.center,
                softWrap: true,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .popUntil((route) => route.settings.name == '/');
                },
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(width * 0.6, width * 0.132)),
                child: Text("Go Back",
                    style: TextStyle(
                        color: primary[900],
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.034))),
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EReciept(
                            amount: amount,
                            item: item,
                            paymentMethod: paymentMethod,
                            date: date,
                            transactionId: transactionId,
                          )));
                },
                style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    backgroundColor: grayscale[200],
                    foregroundColor: grayscale[200],
                    fixedSize: Size(width * 0.6, width * 0.132)),
                child: Text("View E-Reciept",
                    style: TextStyle(
                        color: grayscale[1000],
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.034)))
          ],
        ));
  }
}
