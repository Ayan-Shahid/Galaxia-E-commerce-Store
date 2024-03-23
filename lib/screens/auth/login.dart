import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/authenticate_form_button.dart';
import 'package:galaxia/components/check_box.dart';
import 'package:galaxia/components/email_input.dart';
import 'package:galaxia/components/google_signin_button.dart';
import 'package:galaxia/components/password_input.dart';
import 'package:galaxia/main.dart';

import 'package:galaxia/screens/auth/register.dart';
import 'package:galaxia/theme/theme.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  FormStates formState = FormStates.Default;
  bool rememberMe = true;
  final TextEditingController emailInputController = TextEditingController();
  final TextEditingController passwordInputController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  String? firebaseEmailError;
  String? firebasePasswordError;
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email address!";
    } else if (!value.endsWith(".com")) {
      return "Please enter a valid email address!";
    }
    return null;
  }

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

  forgotPassword() async {
    try {
      if (validateEmail(emailInputController.text) == null) {
        await auth.sendPasswordResetEmail(
          email: emailInputController.text,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  onSubmit() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        formState = FormStates.Validating;
      });
      try {
        UserCredential user = await auth.signInWithEmailAndPassword(
            email: emailInputController.text,
            password: passwordInputController.text);

        await galaxiaStorage.write(
            key: "${user.user?.uid} Email", value: emailInputController.text);
        await galaxiaStorage.write(
            key: "${user.user?.uid} Password",
            value: passwordInputController.text);

        if (mounted) {
          setState(() {
            formState = FormStates.Success;
          });
        }
      } on FirebaseAuthException catch (error) {
        if (error.code == "user-not-found") {
          setState(() {
            firebaseEmailError = "This user does not exist!";
            formState = FormStates.Error;
          });
        } else if (error.code == "wrong-password") {
          setState(() {
            firebasePasswordError =
                "The password is incorrect please try again!";
            formState = FormStates.Error;
          });
        }
      }
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            formState = FormStates.Default;
            firebaseEmailError = null;
            firebasePasswordError = null;
          });
        }
      });
    }
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
              flexibleSpace: Container(
                color: grayscale[100],
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
          child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Text(
              "Login To Your Account",
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  height: 1.5,
                  fontSize: width * 0.09),
            ),
            const SizedBox(
              height: 32,
            ),
            Form(
                key: formKey,
                child: Column(
                  children: [
                    EmailInput(
                        error: firebaseEmailError,
                        validator: validateEmail,
                        controller: emailInputController,
                        enabled:
                            formState == FormStates.Default ? true : false),
                    const SizedBox(
                      height: 24,
                    ),
                    PasswordInput(
                        error: firebasePasswordError,
                        controller: passwordInputController,
                        enabled: formState == FormStates.Default ? true : false,
                        validator: validatePassword),
                    const SizedBox(
                      height: 8,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: primary[500]),
                          onPressed: forgotPassword,
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
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
                      height: 24,
                    ),
                    AuthenticateFormButton(
                        formState: formState,
                        title: "Sign In",
                        onSubmit: onSubmit)
                  ],
                )),
            const SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    height: 2,
                    color: grayscale[200],
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  "or continue with",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Container(
                    height: 2,
                    color: grayscale[200],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(24),
                        foregroundColor: grayscale[300],
                        side:
                            BorderSide(color: grayscale[200] ?? Colors.black)),
                    onPressed: () {},
                    child: SvgPicture.asset(
                      "assets/icons/FaceBook.svg",
                      fit: BoxFit.scaleDown,
                      width: 20,
                    )),
                const SizedBox(
                  width: 32,
                ),
                const SignInWithGoogleButton(),
                const SizedBox(
                  width: 32,
                ),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(24),
                        foregroundColor: grayscale[300],
                        side:
                            BorderSide(color: grayscale[200] ?? Colors.black)),
                    onPressed: () {},
                    child: SvgPicture.asset(
                      "assets/icons/Apple.svg",
                      fit: BoxFit.scaleDown,
                      width: 20,
                    ))
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: grayscale[500]),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Register()));
                    },
                    style: TextButton.styleFrom(foregroundColor: primary[500]),
                    child: Text(
                      "Sign Up",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: primary[500]),
                    ))
              ],
            )
          ],
        ),
      )),
    );
  }
}
