import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:galaxia/theme/theme.dart';

class PopUp extends StatelessWidget {
  final int borderRadius;
  final EdgeInsets padding;
  final Widget content;

  const PopUp(
      {super.key,
      required this.borderRadius,
      required this.padding,
      required this.content});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  color: primary[200]?.withOpacity(0.2),
                ),
              )),
        ),
        Center(
          child: FittedBox(
            child: Container(
              padding: padding,
              decoration: ShapeDecoration(
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(124),
                      side: BorderSide(color: grayscale[400]!)),
                  color: grayscale[100]),
              child: content,
            ),
          ),
        )
      ],
    );
  }
}
