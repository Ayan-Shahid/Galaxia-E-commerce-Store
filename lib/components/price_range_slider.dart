import 'dart:math';

import 'package:flutter/material.dart';
import 'package:galaxia/theme/theme.dart';

class CustomSliderTrackShape extends RangeSliderTrackShape {
  @override
  Rect getPreferredRect(
      {required RenderBox parentBox,
      Offset offset = Offset.zero,
      required SliderThemeData sliderTheme,
      bool? isEnabled,
      bool? isDiscrete}) {
    // TODO: implement getPreferredRect
    final trackHeight = sliderTheme.trackHeight!;
    final top = offset.dy + (parentBox.size.height - trackHeight) / 2;
    return Rect.fromLTWH(
      offset.dx,
      top,
      parentBox.size.width,
      trackHeight,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset,
      {required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required Animation<double> enableAnimation,
      required Offset startThumbCenter,
      required Offset endThumbCenter,
      bool isEnabled = false,
      bool isDiscrete = false,
      required TextDirection textDirection}) {
    if (startThumbCenter > endThumbCenter) {
      final temp = startThumbCenter;
      startThumbCenter = endThumbCenter;
      endThumbCenter = temp;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Paint paint = Paint()
      ..color = primary[500]!
      ..style = PaintingStyle.fill;

    final inactivePaint = Paint()
      ..color = grayscale[200]!
      ..style = PaintingStyle.fill;

    context.canvas.drawRect(
      Rect.fromLTRB(startThumbCenter.dx + offset.dx, trackRect.center.dy + 2,
          endThumbCenter.dx + offset.dx, trackRect.center.dy - 2),
      paint,
    );

    context.canvas.drawRect(
      Rect.fromLTRB(trackRect.left, trackRect.center.dy + 2,
          startThumbCenter.dx, trackRect.center.dy - 2),
      inactivePaint,
    );

    context.canvas.drawRect(
      Rect.fromLTRB(trackRect.right, trackRect.center.dy + 2, endThumbCenter.dx,
          trackRect.center.dy - 2),
      inactivePaint,
    );
    int min = 0;
    int max = (trackRect.center.dy - 12).toInt();

    // Initialize the Random object
    Random random = Random();

    // Generate a random value within the range

    for (int i = startThumbCenter.dx.toInt() - 6;
        i < endThumbCenter.dx - 6;
        i += 6) {
      int randomNumber = min + random.nextInt(max - min + 1);

      context.canvas.drawRect(
        Rect.fromLTRB(
            i + 6, randomNumber.toDouble(), i + 10, trackRect.center.dy - 2),
        inactivePaint,
      );
    }
  }
}

class CustomSliderThumbShape extends RangeSliderThumbShape {
  final double radius;

  CustomSliderThumbShape({this.radius = 10.0});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(radius * 2, radius * 2);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double>? activationAnimation,
    Animation<double>? enableAnimation,
    bool? isDiscrete,
    bool? isOnTop,
    bool? isPressed,
    SliderThemeData? sliderTheme,
    TextDirection? textDirection,
    TextPainter? labelPainter,
    Thumb? thumb,
    bool? isEnabled,
  }) {
    final canvas = context.canvas;
    final paint = Paint()
      ..color = sliderTheme?.thumbColor ?? primary[500]!
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);

    final innerPaint = Paint()
      ..color = primary[100]!
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.5, innerPaint);
  }
}

class PriceRangeSlider extends StatefulWidget {
  final Function(RangeValues)? onChange;
  final RangeValues range;

  const PriceRangeSlider({Key? key, this.onChange, required this.range})
      : super(key: key);

  @override
  PriceRangeSliderState createState() => PriceRangeSliderState();
}

class PriceRangeSliderState extends State<PriceRangeSlider> {
  int? start;
  int? end;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SliderTheme(
        data: SliderTheme.of(context).copyWith(
            trackHeight: width * 0.3,
            showValueIndicator: ShowValueIndicator.always,
            rangeValueIndicatorShape: PaddleRangeSliderValueIndicatorShape(),
            valueIndicatorTextStyle: TextStyle(color: primary[900]),
            rangeTrackShape: CustomSliderTrackShape(),
            rangeThumbShape: CustomSliderThumbShape(radius: 12)),
        child: RangeSlider(
          activeColor: primary[500],
          divisions: 100000,
          labels: RangeLabels("\$$start", "\$$end"),
          inactiveColor: grayscale[200],
          values: widget.range,
          onChanged: (value) {
            setState(() {
              start = value.start.toInt();
              end = value.end.toInt();
            });
            widget.onChange!(value);
          },
          min: 0,
          max: 100000,
        ));
  }
}
