import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/store/payment_methods_state.dart';
import 'package:galaxia/theme/theme.dart';

class ChoosePaymentMethodCard extends StatelessWidget {
  final String icon;
  final PaymentMethodItem method;
  final bool selected;
  final double price;
  final Function() onPressed;
  const ChoosePaymentMethodCard(
      {Key? key,
      required this.icon,
      required this.onPressed,
      required this.method,
      required this.selected,
      required this.price})
      : super(key: key);

  Widget showIcon(double width) {
    if (icon == 'mastercard' || icon == "Mastercard") {
      return Container(
        height: width * 0.1,
        width: width * 0.14,
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: ShapeDecoration(
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(28),
                side: BorderSide(
                    color: selected ? primary[500]! : grayscale[200]!))),
        child: SvgPicture.asset(
          "assets/icons/Mastercard.svg",
        ),
      );
    }
    if (icon == 'discover' || icon == "Discover") {
      return Container(
        height: width * 0.1,
        width: width * 0.14,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: ShapeDecoration(
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(28),
                side: BorderSide(
                    color: selected ? primary[500]! : grayscale[200]!))),
        child: SvgPicture.asset(
          "assets/icons/Discover.svg",
        ),
      );
    } else if (icon == "visa" || icon == "Visa") {
      return Container(
        height: width * 0.1,
        width: width * 0.14,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: ShapeDecoration(
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(28),
                side: BorderSide(
                    color: selected ? primary[500]! : grayscale[200]!))),
        child: SvgPicture.asset(
          "assets/icons/Visa.svg",
          width: width * 0.1,
          color: primary[300],
        ),
      );
    } else if (icon == "jcb" || icon == "JCB") {
      return Container(
        height: width * 0.1,
        width: width * 0.14,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        decoration: ShapeDecoration(
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(28),
                side: BorderSide(
                    color: selected ? primary[500]! : grayscale[200]!))),
        child: SvgPicture.asset(
          "assets/icons/JCB.svg",
          width: width * 0.1,
        ),
      );
    } else if (icon == "unionpay" || icon == "Union") {
      return Container(
        height: width * 0.1,
        width: width * 0.14,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        decoration: ShapeDecoration(
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(28),
                side: BorderSide(
                    color: selected ? primary[500]! : grayscale[200]!))),
        child: SvgPicture.asset(
          "assets/icons/Union.svg",
          width: width * 0.1,
        ),
      );
    } else if (icon == "diners" || icon == "Diners") {
      return Container(
        height: width * 0.1,
        width: width * 0.14,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: ShapeDecoration(
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(28),
                side: BorderSide(
                    color: selected ? primary[500]! : grayscale[200]!))),
        child: SvgPicture.asset(
          "assets/icons/Diners.svg",
          width: width * 0.12,
          color: primary[300],
        ),
      );
    }
    return Container(
      height: width * 0.1,
      width: width * 0.14,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: ShapeDecoration(
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(28),
              side: BorderSide(
                  color: selected ? primary[500]! : grayscale[200]!))),
      child: SvgPicture.asset(
        "assets/icons/Credit Card.svg",
        width: width * 0.12,
        color: primary[300],
      ),
    );
  }

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
                const EdgeInsets.only(left: 24, right: 8, top: 12, bottom: 12),
            shape: ContinuousRectangleBorder(
                side: BorderSide(
                    color: selected ? primary[500]! : grayscale[200]!),
                borderRadius: BorderRadius.circular(56)),
            backgroundColor: selected ? primary[100] : grayscale[100]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            showIcon(width),
            const SizedBox(
              width: 24,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      method.name!,
                      softWrap: true,
                      style: TextStyle(
                          color: grayscale[1000],
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.032),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Visibility(
                        visible: method.isDefault ?? false,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: ShapeDecoration(
                              shape: const StadiumBorder(),
                              color: primary[500]),
                          child: Text(
                            "Default",
                            style: TextStyle(
                                fontSize: width * 0.014, color: primary[900]),
                          ),
                        ))
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "**** **** **** ${method.last4}",
                  softWrap: true,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.024,
                      color: grayscale[1000]),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "Expires ${method.expMonth}/${method.expYear}",
                  softWrap: true,
                  style:
                      TextStyle(fontSize: width * 0.024, color: grayscale[600]),
                ),
              ],
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: selected ? true : false,
                  child: Expanded(
                      child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      "\$${price.toStringAsFixed(1)}",
                      style: TextStyle(
                          color: primary[500],
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.04),
                    ),
                  )),
                ),
                Transform.scale(
                  scale: 1.2,
                  child: Radio(
                    value: selected ? 1 : 0,
                    groupValue: 1,
                    onChanged: (v) {},
                  ),
                ),
              ],
            ))
          ],
        ));
  }
}
