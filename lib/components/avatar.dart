import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/theme/theme.dart';

class Avatar extends StatelessWidget {
  final double size;
  final String? url;

  Widget showImage() {
    return url != "" && url != null
        ? Image.network(
            url!,
            width: size * 1.4,
            height: size * 1.4,
            fit: BoxFit.cover,
          )
        : Positioned(
            bottom: -8,
            child: SvgPicture.asset(
              "assets/icons/User Filled.svg",
              color: grayscale[300],
              width: size * 1.4,
            ),
          );
  }

  const Avatar({super.key, required this.size, this.url = ""});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: grayscale[200],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [showImage()],
      ),
    );
  }
}
