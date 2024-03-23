import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final bool enabled;
  final String? Function(String?) validator;
  final String? error;
  final String? label;

  const PasswordInput(
      {super.key,
      required this.controller,
      required this.enabled,
      required this.validator,
      this.label,
      this.error});
  @override
  PasswordInputState createState() => PasswordInputState();
}

class PasswordInputState extends State<PasswordInput> {
  bool hidden = false;
  toggle() {
    setState(() {
      hidden = !hidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      controller: widget.controller,
      validator: widget.validator,
      style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: hidden,
      decoration: InputDecoration(
          errorText: widget.error,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
          labelText: widget.label ?? "Password",
          suffixIcon: Padding(
            padding: const EdgeInsets.only(left: 24, right: 8),
            child: IconButton(
                onPressed: toggle,
                style: IconButton.styleFrom(shape: const CircleBorder()),
                icon: SvgPicture.asset(
                  "assets/icons/Eye ${hidden ? "Closed" : "Open"}.svg",
                  fit: BoxFit.scaleDown,
                )),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 24, right: 20),
            child: SvgPicture.asset(
              "assets/icons/Lock.svg",
              fit: BoxFit.scaleDown,
            ),
          )),
    );
  }
}
