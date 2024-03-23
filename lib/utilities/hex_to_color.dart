import 'package:flutter/material.dart';

Color hexToColor(String hexString) {
  // Remove the leading '#' character
  hexString = hexString.replaceAll("#", "");

  // Parse the hex string to an integer
  int hexValue = int.parse(hexString, radix: 16);

  // Check if the hex string has an alpha channel
  if (hexString.length == 6) {
    // Add fully opaque alpha channel (0xFF) for colors without alpha
    hexValue = 0xFF000000 | hexValue;
  }

  // Create a Color object from the integer value
  return Color(hexValue);
}
