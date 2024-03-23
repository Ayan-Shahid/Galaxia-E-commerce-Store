import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/theme/theme.dart';

class ShippingModeCard extends StatelessWidget {
  final String icon;
  final String mode;
  final int price;
  final String time;
  final bool selected;
  final Function() onPressed;
  const ShippingModeCard(
      {Key? key,
      required this.icon,
      required this.mode,
      required this.price,
      required this.time,
      required this.selected,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(24),
          foregroundColor: selected ? primary[200] : grayscale[500],
          fixedSize: Size.fromWidth(width),
          elevation: 0.0,
          shape: ContinuousRectangleBorder(
              side: BorderSide(
                  color: selected ? primary[500]! : Colors.transparent),
              borderRadius: BorderRadius.circular(64)),
          backgroundColor: selected ? primary[100] : grayscale[200]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: width * 0.14,
            height: width * 0.14,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? primary[500] : grayscale[1000]),
            child: SvgPicture.asset(
              "assets/icons/$icon.svg",
              color: selected ? primary[900] : grayscale[100],
              width: width * 0.08,
            ),
          ),
          const SizedBox(
            width: 24,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      mode,
                      style: TextStyle(
                          color: selected ? primary[900] : grayscale[1000],
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.04),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    "Estimated Arrival, $time",
                    style: TextStyle(
                        color: grayscale[500], fontSize: width * 0.03),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 24,
          ),
          Text(
            "\$$price",
            style: TextStyle(
                color: selected ? primary[900] : grayscale[1000],
                fontWeight: FontWeight.bold,
                fontSize: width * 0.04),
          ),
          Transform.scale(
            scale: 1.2,
            child: Radio(
              value: selected ? 1 : 0,
              groupValue: 1,
              onChanged: (v) {},
              activeColor: primary[500],
            ),
          )
        ],
      ),
    );
  }
}
