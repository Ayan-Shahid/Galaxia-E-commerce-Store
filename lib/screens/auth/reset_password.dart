import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/authenticate_form_button.dart';

import 'package:galaxia/components/email_input.dart';
import 'package:galaxia/screens/auth/register.dart';
import 'package:galaxia/screens/auth/verify_pin.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  ResetPasswordState createState() => ResetPasswordState();
}

class ResetPasswordState extends State<ResetPassword> {
  String? emailError;

  final TextEditingController emailInputController = TextEditingController();
  FormStates buttonState = FormStates.Default;
  final FirebaseAuth auth = FirebaseAuth.instance;
  navigateToVerifyPin() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => VerifyPin(
              email: emailInputController.text,
            )));
  }

  submit() async {
    try {
      setState(() {
        buttonState = FormStates.Validating;
      });
      auth.sendPasswordResetEmail(
          email: emailInputController.text,
          actionCodeSettings: ActionCodeSettings(url: "/"));
      // navigateToVerifyPin();
      setState(() {
        buttonState = FormStates.Success;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        buttonState = FormStates.Error;
      });
      if (e.code == "user-not-found") {
        setState(() {
          emailError = "There is no user associated with this email!";
        });
      }
      print(e);
    }
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        buttonState = FormStates.Default;
        emailError = null;
      });
    });
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty!';
    } else if (!value.endsWith(".com")) {
      return "Please enter a valid email address!";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: AppBar(
              centerTitle: false,
              title: Text(
                "Forgot Password",
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
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            SvgPicture.asset(
              "assets/illustrations/Forgot Password.svg",
              width: MediaQuery.of(context).size.width * 0.72,
            ),
            Text("Did someone forget their password?",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: width * 0.04)),
            const SizedBox(
              height: 24,
            ),
            Text(
              "That's ok...\n Just enter the email address you've used to\n register with us and we'll send you a code!",
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 24,
            ),
            EmailInput(
                error: emailError,
                validator: validateEmail,
                controller: emailInputController,
                enabled: true),
            const SizedBox(
              height: 24,
            ),
            AuthenticateFormButton(
                formState: buttonState, title: "Submit", onSubmit: submit)
          ],
        ),
      ),
    );
  }
}
