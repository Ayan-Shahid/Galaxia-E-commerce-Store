import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/google_signin_button.dart';

import 'package:galaxia/screens/auth/login.dart';

import 'package:galaxia/screens/auth/register.dart';
import 'package:galaxia/theme/theme.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  GetStartedState createState() => GetStartedState();
}

class GetStartedState extends State<GetStarted> {
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
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    "assets/icons/Left Arrow.svg",
                    width: 32,
                    height: 32,
                  )),
            ),
          )),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 24,
            ),
            Container(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                "assets/illustrations/Sign In.svg",
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * 0.6,
              ),
            ),
            const SizedBox(
              height: 56,
            ),
            Text(
              "Let's You In",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: width * 0.08),
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: grayscale[400],
                      side: BorderSide(color: grayscale[200] ?? Colors.black),
                      padding: const EdgeInsets.symmetric(vertical: 20)),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/icons/FaceBook.svg"),
                      const SizedBox(
                        width: 12,
                      ),
                      Text("Continue With FaceBook",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: grayscale[1000],
                            fontSize: width * 0.032,
                          ))
                    ],
                  )),
            ),
            const SizedBox(
              height: 24,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: SignInWithGoogleButton(
                type: GoogleSignInButtonType.normal,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: grayscale[400],
                      side: BorderSide(color: grayscale[200] ?? Colors.black),
                      padding: const EdgeInsets.symmetric(vertical: 20)),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/icons/Apple.svg"),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        "Continue With Apple",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: grayscale[1000],
                          fontSize: width * 0.032,
                        ),
                      )
                    ],
                  )),
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
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
                    "or",
                    style: TextStyle(fontSize: width * 0.032),
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
            ),
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20)),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => const Login()));
                  },
                  child: Text(
                    "Sign In With Password",
                    style: TextStyle(
                        fontSize: width * 0.032,
                        fontWeight: FontWeight.bold,
                        color: primary[900]),
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Don’t have an account? ",
                  style:
                      TextStyle(color: grayscale[500], fontSize: width * 0.032),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => const Register()));
                    },
                    style: TextButton.styleFrom(foregroundColor: primary[500]),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: primary[500], fontSize: width * 0.032),
                    ))
              ],
            )
          ],
        ),
      )),
    );
  }
}
