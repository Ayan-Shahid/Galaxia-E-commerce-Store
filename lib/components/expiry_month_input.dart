import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class ExpiryMonthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    if (text.length == 1 && int.parse(text) > 1) {
      // Ensure the first digit is 0 or 1
      return TextEditingValue(
        text: '0$text',
        selection: const TextSelection.collapsed(offset: 3),
      );
    } else if (text.length == 2) {
      // Ensure the month is within a valid range (01 - 12)
      final month = int.parse(text);
      if (month < 1) {
        return const TextEditingValue(
          text: '01',
          selection: TextSelection.collapsed(offset: 2),
        );
      } else if (month > 12) {
        return const TextEditingValue(
          text: '12',
          selection: TextSelection.collapsed(offset: 2),
        );
      }
    }

    return newValue;
  }
}

class ExpiryMonthInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChange;
  final String? error;
  const ExpiryMonthInput(
      {super.key, required this.controller, this.error, this.onChange});
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your card expiry month!";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      onChanged: onChange,
      validator: validate,
      keyboardType: TextInputType.datetime,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(2),
        ExpiryMonthInputFormatter()
      ],
      decoration: InputDecoration(
        errorText: error,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 24, right: 20),
          child: SvgPicture.asset("assets/icons/Calendar.svg"),
        ),
        labelText: "Month",
      ),
    );
  }
}
