import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class CvcInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Implement CVC formatting logic
    final text =
        newValue.text.replaceAll(RegExp(r'\D'), ''); // Remove non-digits
    final formattedText = _formatCvc(text);
    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _formatCvc(String input) {
    // Ensure CVC does not exceed 3 digits
    if (input.length > 3) {
      input = input.substring(0, 3);
    }
    return input;
  }
}

class CVCInput extends StatelessWidget {
  final TextEditingController controller;
  final String? error;
  const CVCInput({super.key, required this.controller, this.error});
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter cvc!";
    } else if (int.parse(value) < 3) {
      return "Invalid Cvc";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validate,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CvcInputFormatter()
      ],
      decoration: InputDecoration(
          errorText: error,
          labelText: "CVC",
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 24, right: 20),
            child: SvgPicture.asset(
              "assets/icons/Security.svg",
              fit: BoxFit.scaleDown,
            ),
          )),
    );
  }
}
