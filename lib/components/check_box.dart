import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/theme/theme.dart';

class CheckBox extends StatelessWidget {
  final Function()? onTap;
  final bool selected;
  const CheckBox({super.key, this.onTap, this.selected = false});
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onTap,
        splashColor: selected ? primary[200] : grayscale[500],
        icon: Container(
          width: 24,
          height: 24,
          decoration: ShapeDecoration(
              color: selected ? primary[500] : Colors.transparent,
              shape: ContinuousRectangleBorder(
                  side: BorderSide(
                      color: selected ? Colors.transparent : grayscale[400]!),
                  borderRadius: const BorderRadius.all(Radius.circular(18)))),
          child: Visibility(
              visible: selected,
              child: Container(
                  padding: const EdgeInsets.all(4),
                  child: SvgPicture.asset(
                    "assets/icons/Check.svg",
                    fit: BoxFit.scaleDown,
                  ))),
        ));
  }
}
