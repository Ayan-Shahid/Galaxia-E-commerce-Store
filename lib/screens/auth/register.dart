import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/authenticate_form_button.dart';
import 'package:galaxia/components/check_box.dart';
import 'package:galaxia/components/email_input.dart';
import 'package:galaxia/components/google_signin_button.dart';
import 'package:galaxia/components/password_input.dart';
import 'package:galaxia/components/username_input.dart';
import 'package:galaxia/main.dart';
import 'package:galaxia/providers/profile_setup_provider.dart';

import 'package:galaxia/screens/auth/login.dart';
import 'package:galaxia/screens/auth/profile_setup.dart';
import 'package:galaxia/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  RegisterState createState() => RegisterState();
}

enum FormStates { Default, Error, Validating, Success }

class RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  FormStates formState = FormStates.Default;
  String firebaseEmailError = "";
  bool rememberMe = true;

  setRememberMe() {
    setState(() {
      rememberMe = !rememberMe;
    });
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController usernameInputController = TextEditingController();
  final TextEditingController emailInputController = TextEditingController();
  final TextEditingController passwordInputController = TextEditingController();

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username cannot be empty!';
    } else if (value.length < 4) {
      return "Username cannot be less then 4 characters!";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty!';
    } else if (value.length < 4) {
      return "Password cannot be less then 4 characters!";
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty!';
    } else if (!value.endsWith(".com")) {
      return "Please enter a valid email address!";
    }
    return null;
  }

  setProfileState() {
    if (mounted) {
      Provider.of<ProfileSetupProvider>(context, listen: false)
          .setProfileSetup(false);
    }
  }

  navigateToSetUpProfile() {
    if (mounted) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const ProfileSetUp(),
      ));
    }
  }

  onSubmit() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        formState = FormStates.Validating;
      });
      try {
        UserCredential user = await auth.createUserWithEmailAndPassword(
            email: emailInputController.text,
            password: passwordInputController.text);

        await user.user?.updateDisplayName(usernameInputController.text);

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
        setProfileState();
        navigateToSetUpProfile();
      } on FirebaseAuthException catch (error) {
        print(error);
        setState(() {
          formState = FormStates.Error;
        });
        if (error.code == 'email-already-in-use') {
          setState(() {
            firebaseEmailError = "This email address is already in use!";
          });
        } else if (error.code == 'invalid-email') {}
      } finally {
        if (mounted) {
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              formState = FormStates.Default;
              firebaseEmailError = "";
            });
          });
        }
      }
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
              "Create Your Account",
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
                    UsernameInput(
                        validator: validateUsername,
                        controller: usernameInputController,
                        enabled:
                            formState == FormStates.Default ? true : false),
                    const SizedBox(
                      height: 24,
                    ),
                    EmailInput(
                      error:
                          firebaseEmailError == "" ? null : firebaseEmailError,
                      validator: validateEmail,
                      controller: emailInputController,
                      enabled: formState == FormStates.Default ? true : false,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    PasswordInput(
                        controller: passwordInputController,
                        enabled: formState == FormStates.Default ? true : false,
                        validator: validatePassword),
                    const SizedBox(
                      height: 16,
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
                      onSubmit: onSubmit,
                      formState: formState,
                      title: "Sign Up",
                    ),
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
                        foregroundColor: grayscale[600],
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
                SignInWithGoogleButton(),
                const SizedBox(
                  width: 32,
                ),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(24),
                        foregroundColor: grayscale[600],
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
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: grayscale[500]),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Login()));
                    },
                    style: TextButton.styleFrom(foregroundColor: primary[500]),
                    child: Text(
                      "Sign In",
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
