// ignore_for_file: always_specify_types

import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/theme/theme.dart';

Widget buildBarcode(
  Barcode bc,
  String data, {
  String? filename,
  double? width,
  double? height,
  double? fontHeight,
}) {
  /// Create the Barcode
  final svg = bc.toSvg(
    data,
    color: grayscale[1000]!.value,
    width: width ?? 200,
    height: height ?? 80,
    fontHeight: fontHeight,
  );

  return SvgPicture.string(svg);
}
