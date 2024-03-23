import 'package:flutter/material.dart';

Map<int, Color> lerpColors(
    Map<int, Color> colors, Map<int, Color> other, double t) {
  Map<int, Color> newColors = {};

  for (int key in colors.keys) {
    newColors[key] = Color.lerp(colors[key], other[key], t)!;
  }
  return newColors;
}

@immutable
class GalaxiaTheme extends ThemeExtension<GalaxiaTheme> {
  const GalaxiaTheme({
    required this.primary,
    required this.grayscale,
  });
  final Map<int, Color> primary;
  final Map<int, Color> grayscale;

  @override
  GalaxiaTheme copyWith({
    Map<int, Color>? primary,
    Map<int, Color>? grayscale,
  }) {
    return GalaxiaTheme(
      primary: primary!,
      grayscale: grayscale!,
    );
  }

  @override
  GalaxiaTheme lerp(GalaxiaTheme? other, double t) {
    if (other is! GalaxiaTheme) {
      return this;
    }

    return GalaxiaTheme(
      primary: lerpColors(primary, other.primary, t),
      grayscale: lerpColors(grayscale, other.grayscale, t),
    );
  }
}
