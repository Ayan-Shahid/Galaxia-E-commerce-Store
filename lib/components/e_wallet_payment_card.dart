import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:galaxia/theme/theme.dart';

class EWalletPaymentCard extends StatelessWidget {
  final bool selected;
  final double price;
  final Function() onPressed;
  const EWalletPaymentCard(
      {Key? key,
      required this.onPressed,
      required this.selected,
      required this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            fixedSize: Size.fromWidth(width),
            foregroundColor: selected ? primary[200] : grayscale[500],
            elevation: 0.0,
            padding:
                const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
            shape: ContinuousRectangleBorder(
                side: BorderSide(
                    color: selected ? primary[500]! : grayscale[200]!),
                borderRadius: BorderRadius.circular(48)),
            backgroundColor: selected ? primary[100] : grayscale[100]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: SvgPicture.asset(
                "assets/icons/Wallet Filled.svg",
                width: width * 0.08,
              ),
            ),
            const SizedBox(
              width: 24,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "E-Wallet",
                  softWrap: true,
                  style: TextStyle(
                      color: grayscale[1000],
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.032),
                ),
                const SizedBox(
                  width: 16,
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                    visible: selected ? true : false,
                    child: Text(
                      "\$${price.toStringAsFixed(1)}",
                      style: TextStyle(
                          color: primary[500],
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.04),
                    )),
                Transform.scale(
                  scale: 1.2,
                  child: Radio(
                    value: selected ? 1 : 0,
                    groupValue: 1,
                    onChanged: (v) {},
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
