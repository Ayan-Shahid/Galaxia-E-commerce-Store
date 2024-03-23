import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UsernameInput extends StatelessWidget {
  final String? Function(String?) validator;
  final TextEditingController controller;
  final bool enabled;
  const UsernameInput(
      {super.key,
      required this.validator,
      required this.controller,
      required this.enabled});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 68),
          labelText: "Username",
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 24, right: 20),
            child: SvgPicture.asset(
              "assets/icons/User Filled.svg",
              fit: BoxFit.scaleDown,
            ),
          )),
    );
  }
}
