import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/theme/theme.dart';

class Notification extends StatelessWidget {
  const Notification({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      clipBehavior: Clip.antiAlias,
      width: MediaQuery.of(context).size.width,
      decoration: ShapeDecoration(
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(56)),
          color: grayscale[200]),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: grayscale[300]),
            child: SvgPicture.asset(
              "assets/icons/Wallet Filled.svg",
              fit: BoxFit.scaleDown,
            ),
          ),
          const SizedBox(
            width: 24,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "30% Special Discount!",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.46,
                child: Text(
                  "Special promotion only valid today",
                  softWrap: true,
                  style: TextStyle(
                    color: grayscale[500],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
