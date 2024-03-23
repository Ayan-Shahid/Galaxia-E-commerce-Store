import 'package:flutter/material.dart';
import 'package:galaxia/theme/theme.dart';

class GalaxiaSwitch extends StatefulWidget {
  const GalaxiaSwitch({Key? key}) : super(key: key);

  @override
  GalaxiaSwitchState createState() => GalaxiaSwitchState();
}

class GalaxiaSwitchState extends State<GalaxiaSwitch> {
  bool selected = true;
  @override
  Widget build(BuildContext context) {
    return Switch(
        value: selected,
        inactiveThumbColor: grayscale[300],
        trackOutlineColor: MaterialStatePropertyAll(grayscale[100]),
        thumbColor: MaterialStateProperty.resolveWith((states) =>
            states.contains(MaterialState.selected)
                ? primary[500]
                : grayscale[300]),
        trackColor: MaterialStateProperty.resolveWith((states) =>
            states.contains(MaterialState.selected)
                ? primary[100]
                : grayscale[200]),
        activeColor: primary[100],
        onChanged: (value) {
          setState(() {
            selected = value;
          });
        });
  }
}
