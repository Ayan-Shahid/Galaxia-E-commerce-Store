import 'package:flutter/material.dart';
import 'package:galaxia/components/carousal_indicator.dart';

class ImageCarousal extends StatefulWidget {
  final List<String> images;
  const ImageCarousal({super.key, required this.images});
  @override
  ImageCarousalState createState() => ImageCarousalState();
}

class ImageCarousalState extends State<ImageCarousal> {
  int current = 0;
  slide(int index) {
    setState(() {
      current = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PageView.builder(
          itemCount: widget.images.length,
          onPageChanged: (value) => slide(value),
          itemBuilder: (context, index) => SizedBox(
            width: double.infinity,
            child: Image.network(
              widget.images[index],
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 24,
          child: CarousalIndicator(
            current: current,
            length: widget.images.length,
          ),
        ),
      ],
    );
  }
}
