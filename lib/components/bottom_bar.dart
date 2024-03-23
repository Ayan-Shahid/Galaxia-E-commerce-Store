import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/theme/theme.dart';

class BottomNavigationItem extends StatelessWidget {
  final String icon;
  final String label;
  final Color color;
  final void Function() onPressed;

  const BottomNavigationItem(
      {super.key, required this.icon,
      required this.label,
      required this.color,
      required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
          foregroundColor: grayscale[1000]),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/icons/$icon.svg",
            color: color,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            label,
            style: TextStyle(fontSize: 14, color: color),
          )
        ],
      ),
    );
  }
}

class BottomBar extends StatefulWidget {
  final Function(int)? onChange;
  const BottomBar({super.key, this.onChange});
  @override
  BottomBarState createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  int current = 0;
  select(int index) {
    setState(() {
      current = index;
    });
    widget.onChange!(current);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.12,
      width: MediaQuery.of(context).size.width,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: grayscale[100]?.withOpacity(0.8)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.only(top: 0, bottom: 12),
          height: MediaQuery.of(context).size.height * 0.12,
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BottomNavigationItem(
                onPressed: () => select(0),
                icon: "Home ${current == 0 ? "Filled" : "Outlined"}",
                label: "Home",
                color: current == 0 ? primary[500]! : grayscale[1000]!,
              ),
              BottomNavigationItem(
                icon: "Bag ${current == 1 ? "Filled" : "Outlined"}",
                onPressed: () => select(1),
                label: "Cart",
                color: current == 1 ? primary[500]! : grayscale[1000]!,
              ),
              BottomNavigationItem(
                onPressed: () => select(2),
                icon: "Cart ${current == 2 ? "Filled" : "Outlined"}",
                label: "Orders",
                color: current == 2 ? primary[500]! : grayscale[1000]!,
              ),
              BottomNavigationItem(
                onPressed: () => select(3),
                icon: "Wallet ${current == 3 ? "Filled" : "Outlined"}",
                label: "Wallet",
                color: current == 3 ? primary[500]! : grayscale[1000]!,
              ),
              BottomNavigationItem(
                onPressed: () => select(4),
                icon: "User ${current == 4 ? "Filled" : "Outlined"}",
                label: "Profile",
                color: current == 4 ? primary[500]! : grayscale[1000]!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
