import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Implement card number formatting logic
    final text =
        newValue.text.replaceAll(RegExp(r'\D'), ''); // Remove non-digits
    final formattedText = _formatCardNumber(text);
    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _formatCardNumber(String input) {
    if (input.length > 16) {
      input = input.substring(0, 16);
    }
    final List<String> chunks = [];
    for (int i = 0; i < input.length; i += 4) {
      chunks.add(input.substring(i, i + 4));
    }
    return chunks.join(' ');
  }
}

class CardNumberInput extends StatefulWidget {
  final TextEditingController controller;
  final String? error;
  const CardNumberInput({super.key, required this.controller, this.error});
  @override
  CardNumberInputState createState() => CardNumberInputState();
}

class CardNumberInputState extends State<CardNumberInput> {
  final List<Widget> cards = [
    SvgPicture.asset(
      "assets/cards/Empty.svg",
      width: 24,
    ),
    SvgPicture.asset(
      "assets/cards/Visa.svg",
      width: 32,
    ),
    SvgPicture.asset(
      "assets/cards/Mastercard.svg",
      width: 32,
    ),
    SvgPicture.asset(
      "assets/cards/American Express.svg",
      width: 32,
    ),
    SvgPicture.asset(
      "assets/cards/Discover.svg",
      width: 32,
    ),
    SvgPicture.asset(
      "assets/cards/Diners.svg",
      width: 32,
    ),
  ];

  int card = 0;
  decideCard(String value) {
    if (value.startsWith("36") || value.startsWith("38")) {
      setState(() {
        card = 5;
      });
    } else if (value.startsWith('3')) {
      setState(() {
        card = 3;
      });
    } else if (value.startsWith('4')) {
      setState(() {
        card = 1;
      });
    } else if (value.startsWith('5')) {
      setState(() {
        card = 2;
      });
    } else if (value.startsWith('6')) {
      setState(() {
        card = 4;
      });
    } else {
      setState(() {
        card = 0;
      });
    }
  }

  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your card number!";
    } else if (value.length < 19) {
      return "Invalid card number!";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.controller,
      validator: validate,
      keyboardType: TextInputType.number,
      onChanged: (value) => decideCard(value),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CardNumberInputFormatter()
      ],
      decoration: InputDecoration(
          errorText: widget.error,
          labelText: "Card Number",
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 24, right: 20),
            child: cards[card],
          )),
    );
  }
}
