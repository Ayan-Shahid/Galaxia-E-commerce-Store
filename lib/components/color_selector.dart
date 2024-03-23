import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/theme/theme.dart';
import 'package:galaxia/utilities/hex_to_color.dart';

class ColorSelector extends StatefulWidget {
  final List<String> colors;
  final Function(String)? onChange;

  const ColorSelector({super.key, required this.colors, this.onChange});
  @override
  ColorSelectorState createState() => ColorSelectorState();
}

class ColorSelectorState extends State<ColorSelector> {
  int selected = 0;
  select(int index) {
    setState(() {
      selected = index;
    });
    widget.onChange!(widget.colors[selected]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 12,
        ),
        SizedBox(
          width: 56 + 56 + 12,
          height: 56,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12),
            itemCount: widget.colors.length,
            itemBuilder: (context, index) => ElevatedButton(
                onPressed: () {
                  select(index);
                },
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(56, 56),
                    foregroundColor: grayscale[100],
                    backgroundColor: hexToColor(widget.colors[index])),
                child: selected == index
                    ? SvgPicture.asset("assets/icons/Check.svg")
                    : null),
          ),
        ),
      ],
    );
  }
}
