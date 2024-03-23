import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/theme/theme.dart';

class Counter extends StatefulWidget {
  final Function(int)? onChange;
  final TextStyle? countStyle;
  final double? iconSize;
  final double? padding;
  final EdgeInsets? containerPadding;
  final int? value;
  const Counter(
      {super.key,
      this.onChange,
      this.padding,
      this.value,
      this.countStyle,
      this.iconSize,
      this.containerPadding});
  @override
  CounterState createState() => CounterState();
}

class CounterState extends State<Counter> {
  int count = 1;
  increment() {
    setState(() {
      count += 1;
    });
    widget.onChange!(count);
  }

  decrement() {
    if (count == 1) return;
    setState(() {
      count -= 1;
    });
    widget.onChange!(count);
  }

  @override
  void initState() {
    super.initState();
    if (widget.value != null) count = widget.value!;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.zero,
      decoration:
          ShapeDecoration(shape: const StadiumBorder(), color: grayscale[200]),
      child: Row(
        children: [
          SizedBox(
            width: widget.iconSize ?? width * 0.078,
            height: widget.iconSize ?? width * 0.078,
            child: IconButton(
                onPressed: decrement,
                padding: EdgeInsets.all(widget.padding ?? 8),
                icon: SvgPicture.asset(
                  "assets/icons/Minus.svg",
                  fit: BoxFit.scaleDown,
                )),
          ),
          Text('$count',
              style: widget.countStyle ??
                  TextStyle(
                      fontWeight: FontWeight.bold, fontSize: width * 0.032)),
          SizedBox(
            width: widget.iconSize ?? width * 0.078,
            height: widget.iconSize ?? width * 0.078,
            child: IconButton(
                onPressed: increment,
                style: IconButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: EdgeInsets.all(widget.padding ?? 8),
                ),
                icon: SvgPicture.asset(
                  "assets/icons/Plus.svg",
                )),
          )
        ],
      ),
    );
  }
}
