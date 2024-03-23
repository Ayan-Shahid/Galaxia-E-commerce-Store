import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmailInput extends StatelessWidget {
  final String? error;
  final String? Function(String?) validator;
  final TextEditingController controller;
  final bool enabled;
  const EmailInput(
      {super.key,
      required this.error,
      required this.validator,
      required this.controller,
      required this.enabled});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03),
      enabled: enabled,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      decoration: InputDecoration(
          errorText: error,
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          labelText: "Email",
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 24, right: 20),
            child: SvgPicture.asset(
              "assets/icons/Email Filled.svg",
              fit: BoxFit.scaleDown,
            ),
          )),
    );
  }
}
