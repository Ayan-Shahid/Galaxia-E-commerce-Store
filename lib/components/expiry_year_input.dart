import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class ExpiryYearInput extends StatelessWidget {
  final TextEditingController controller;
  final String? error;
  const ExpiryYearInput({super.key, required this.controller, this.error});
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your card expiry year!";
    } else if (int.parse(value) < DateTime.now().year % 100) {
      return "Card is expired!";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validate,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(2),
      ],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        errorText: error,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 24, right: 20),
          child: SvgPicture.asset("assets/icons/Calendar.svg"),
        ),
        labelText: "Year",
      ),
    );
  }
}
