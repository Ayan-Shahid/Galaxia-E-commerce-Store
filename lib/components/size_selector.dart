import 'package:flutter/material.dart';
import 'package:galaxia/theme/theme.dart';

class SizeSelector extends StatefulWidget {
  final List<String> sizes;
  final Function(String)? onChange;

  const SizeSelector({super.key, required this.sizes, this.onChange});
  @override
  SizeSelectorState createState() => SizeSelectorState();
}

class SizeSelectorState extends State<SizeSelector> {
  int selected = 0;
  select(int index) {
    setState(() {
      selected = index;
    });
    widget.onChange!(widget.sizes[selected]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Size",
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 12,
        ),
        SizedBox(
          height: 56,
          width: 56 + 56 + 12,
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: widget.sizes.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12),
            itemBuilder: (context, index) => OutlinedButton(
              onPressed: () {
                select(index);
              },
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  backgroundColor:
                      selected == index ? primary[100] : Colors.transparent,
                  fixedSize: const Size(56, 56),
                  side: BorderSide(
                      color:
                          selected == index ? primary[500]! : grayscale[300]!)),
              child: Text(
                widget.sizes[index],
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        )
      ],
    );
  }
}
