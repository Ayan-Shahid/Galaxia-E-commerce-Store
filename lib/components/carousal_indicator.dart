import 'package:flutter/material.dart';
import 'package:galaxia/theme/theme.dart';

class CarousalIndicator extends StatelessWidget {
  final int current;
  final int length;
  const CarousalIndicator({super.key, required this.current, required this.length});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
        (index) {
          bool isSelected = index == current;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isSelected ? 32 : 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: isSelected ? primary[500] : grayscale[200],
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
          );
        },
      ),
    );
  }
}
