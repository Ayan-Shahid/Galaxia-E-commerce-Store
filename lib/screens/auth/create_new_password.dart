import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/authenticate_form_button.dart';
import 'package:galaxia/components/check_box.dart';
import 'package:galaxia/components/password_input.dart';
import 'package:galaxia/screens/auth/register.dart';

class CreateNewPassword extends StatefulWidget {
  final Function(String passwod)? onSubmit;
  final FormStates? buttonState;
  const CreateNewPassword({Key? key, this.onSubmit, this.buttonState})
      : super(key: key);

  @override
  CreateNewPasswordState createState() => CreateNewPasswordState();
}

class CreateNewPasswordState extends State<CreateNewPassword> {
  final TextEditingController passwordInputController = TextEditingController();
  final TextEditingController retypePasswordController =
      TextEditingController();
  bool rememberMe = true;
  setRememberMe() {
    setState(() {
      rememberMe = !rememberMe;
    });
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty!';
    } else if (value.length < 4) {
      return "Password cannot be less then 4 characters!";
    }
    return null;
  }

  String? validateRetype(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please re-enter your password!';
    } else if (value != passwordInputController.text) {
      return "Please re-type the same password!";
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
                "Create New Password",
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
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            SvgPicture.asset(
              "assets/illustrations/Reset Password.svg",
              width: width * 0.9,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Create your new password",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: width * 0.04),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Form(
                child: Column(
              children: [
                PasswordInput(
                    controller: passwordInputController,
                    enabled: true,
                    validator: validatePassword),
                const SizedBox(
                  height: 24,
                ),
                PasswordInput(
                    label: "Re Enter Password",
                    controller: retypePasswordController,
                    enabled: true,
                    validator: validateRetype),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CheckBox(
                      selected: rememberMe,
                      onTap: setRememberMe,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      "Remember Me",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                AuthenticateFormButton(
                    formState: widget.buttonState ?? FormStates.Default,
                    title: "Continue",
                    onSubmit: () {
                      widget.onSubmit!(passwordInputController.text);
                    })
              ],
            ))
          ],
        ),
      )),
    );
  }
}
