import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/authenticate_form_button.dart';

import 'package:galaxia/main.dart';
import 'package:galaxia/providers/local_notification_service.dart';
import 'package:galaxia/screens/auth/register.dart';
import 'package:galaxia/store/app_state.dart';
import 'package:galaxia/theme/theme.dart';

class ConfirmTopUp extends StatefulWidget {
  const ConfirmTopUp({Key? key, required this.amount}) : super(key: key);
  final double amount;

  @override
  ConfirmTopUpState createState() => ConfirmTopUpState();
}

class ConfirmTopUpState extends State<ConfirmTopUp> {
  final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());
  final GlobalKey<ConfirmTopUpState> buildcontext = GlobalKey();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FormStates buttonState = FormStates.Default;
  bool pinError = false;
  final List<TextEditingController> controllers =
      List.generate(4, (index) => TextEditingController());
  confirmPayment() async {
    try {
      final DocumentReference document =
          firestore.collection("E-Wallet").doc(auth.currentUser?.uid);
      firestore.runTransaction((transaction) async {
        num balance = await transaction
            .get(document)
            .then((value) => value.get("Balance"));
        transaction.update(document, {
          "Balance": balance + widget.amount,
        });
        transaction.set(document.collection("Transaction").doc(), {
          "Date": Timestamp.now(),
          "Title": "Top Up",
          "Image": null,
          "Price": widget.amount,
          "Type": "Top Up"
        });
      });

      LocalNotificationService().showNotification(
          title: "Top Up Successful!", body: "Your wallet has been updated!");
    } catch (e) {
      print(e);
    }
  }

  submit() async {
    setState(() {
      buttonState = FormStates.Validating;
    });
    String pin =
        '${controllers[0].text}${controllers[1].text}${controllers[2].text}${controllers[3].text}';
    try {
      final PIN =
          await galaxiaStorage.read(key: "${auth.currentUser?.uid} PIN");
      if (pin == PIN) {
        await confirmPayment();
        setState(() {
          buttonState = FormStates.Success;
        });
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pushNamed("/");
        });
      } else {
        setState(() {
          pinError = true;
        });
        controllers.forEach((controller) {
          controller.clear();
        });

        // Move focus back to the first input
        FocusScope.of(context).requestFocus(focusNodes[0]);
        setState(() {
          buttonState = FormStates.Error;
        });
        Future.delayed(Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              pinError = false;
            });
          }
        });
      }
    } catch (error) {
      print(error);
      setState(() {
        buttonState = FormStates.Error;
      });
    }
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          buttonState = FormStates.Default;
        });
      }
    });
  }

  void _onFourthDigitChanged() async {
    if (controllers[3].text.length == 1) {
      // Automatically submit input when 4 digits are entered
      submit();
    }
  }

  @override
  void initState() {
    super.initState();
    controllers[3].addListener(_onFourthDigitChanged);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return StoreBuilder<AppState>(builder: (galaxiastorecontext, galaxiastore) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(52),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: AppBar(
                centerTitle: false,
                title: Text(
                  "Confirm Top Up",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: SvgPicture.asset(
                      "assets/icons/Left Arrow.svg",
                      width: 32,
                      height: 32,
                    )),
              ),
            )),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Enter your pin to confirm the payment!",
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      4,
                      (index) => Container(
                        width: width * 0.17,
                        height: width * 0.17,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: TextFormField(
                          controller: controllers[index],
                          focusNode: focusNodes[index],
                          autofocus: index == 0,
                          maxLength: 1,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (value.length == 1 && index < 3) {
                              FocusScope.of(context)
                                  .requestFocus(focusNodes[index + 1]);
                            }
                          },
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(counterText: ""),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Visibility(
                    visible: pinError,
                    child: Text(
                      "Incorrect PIN Try Again!",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: error[500]),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              )),
              AuthenticateFormButton(
                  formState: buttonState, title: "Continue", onSubmit: submit)
            ],
          ),
        )),
      );
    });
  }
}
