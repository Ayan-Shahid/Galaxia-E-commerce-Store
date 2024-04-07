import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/authenticate_form_button.dart';

import 'package:galaxia/main.dart';

import 'package:galaxia/screens/auth/create_new_password.dart';
import 'package:galaxia/screens/auth/register.dart';
import 'package:galaxia/store/app_state.dart';

import 'package:galaxia/theme/theme.dart';

class VerifyPin extends StatefulWidget {
  const VerifyPin({Key? key}) : super(key: key);

  @override
  VerifyPinState createState() => VerifyPinState();
}

class VerifyPinState extends State<VerifyPin> {
  final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());
  bool pinError = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FormStates buttonState = FormStates.Default;
  FormStates newbuttonState = FormStates.Default;

  final List<TextEditingController> controllers =
      List.generate(4, (index) => TextEditingController());
  navigateToChangePassword() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CreateNewPassword(
              buttonState: newbuttonState,
              onSubmit: (password) => changePassword(password),
            )));
  }

  goBack() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  changePassword(String password) async {
    try {
      setState(() {
        newbuttonState = FormStates.Validating;
      });
      await auth.currentUser?.updatePassword(password);
      setState(() {
        newbuttonState = FormStates.Success;
      });
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          newbuttonState = FormStates.Success;
        });
      });
      Future.delayed(const Duration(seconds: 3), () {
        goBack();
      });
    } catch (e) {
      print(e);

      setState(() {
        buttonState = FormStates.Error;
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            newbuttonState = FormStates.Default;
          });
        }
      });
    }
  }

  submit() async {
    String pin =
        '${controllers[0].text}${controllers[1].text}${controllers[2].text}${controllers[3].text}';
    setState(() {
      buttonState = FormStates.Validating;
    });
    try {
      final PIN =
          await galaxiaStorage.read(key: "${auth.currentUser?.uid} PIN");
      if (pin == PIN) {
        final email =
            await galaxiaStorage.read(key: "${auth.currentUser?.uid} Email");
        final password =
            await galaxiaStorage.read(key: "${auth.currentUser?.uid} Password");

        await auth.currentUser?.reauthenticateWithCredential(
            EmailAuthProvider.credential(email: email!, password: password!));

        await navigateToChangePassword();
        setState(() {
          buttonState = FormStates.Success;
        });
        Future.delayed(Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              buttonState = FormStates.Default;
            });
          }
        });
      } else {
        for (TextEditingController element in controllers) {
          element.clear();
        }
        focusNodes[0].requestFocus();
        setState(() {
          pinError = true;
          buttonState = FormStates.Error;
        });
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            pinError = false;
            buttonState = FormStates.Default;
          });
        });
      }
    } catch (error) {
      print(error);
      setState(() {
        buttonState = FormStates.Error;
      });
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            buttonState = FormStates.Default;
          });
        }
      });
    }
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
                  "Enter Your Pin",
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
                    "Enter your pin to change your password!",
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
                        width: 75,
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
                      "Invalid PIN Try Again!",
                      style:
                          TextStyle(fontSize: width * 0.036, color: error[500]),
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
