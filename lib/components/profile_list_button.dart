import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/theme/theme.dart';

class ProfileListButton extends StatelessWidget {
  final String icon;
  final String name;
  final Function()? onPressed;
  const ProfileListButton(
      {Key? key, required this.name, required this.icon, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      child: TextButton(
          style: TextButton.styleFrom(
              shape: const ContinuousRectangleBorder(),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              foregroundColor: grayscale[1000]),
          onPressed: onPressed,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset("assets/icons/$icon.svg"),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: grayscale[1000]),
                  )
                ],
              ),
              IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset("assets/icons/Carrot Right.svg"))
            ],
          )),
    );
  }
}
