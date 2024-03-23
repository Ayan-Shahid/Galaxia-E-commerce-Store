import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/google_signin_cancelled_popup.dart';
import 'package:galaxia/components/google_signin_network_error_popup.dart';

import 'package:galaxia/providers/profile_setup_provider.dart';
import 'package:galaxia/screens/auth/login.dart';
import 'package:galaxia/screens/auth/profile_setup.dart';
import 'package:galaxia/screens/auth/register.dart';
import 'package:galaxia/theme/theme.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  GetStartedState createState() => GetStartedState();
}

class GetStartedState extends State<GetStarted> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GlobalKey<GetStartedState> buildcontext = GlobalKey();

  setProfileState() {
    Provider.of<ProfileSetupProvider>(context, listen: false)
        .setProfileSetup(false);
  }

  navigateToSetUpProfile() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const ProfileSetUp(),
    ));
  }

  _signInWithGoogle() async {
    try {
      // Trigger the Google Sign In process
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        throw PlatformException(code: GoogleSignIn.kSignInCanceledError);
      }

      // Get GoogleSignInAuthentication object
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      // Create GoogleAuthCredential using the GoogleSignInAuthentication object
      final OAuthCredential googleAuthCredential =
          GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      // Sign in with Google Auth credentials
      final UserCredential authResult =
          await auth.signInWithCredential(googleAuthCredential);

      authResult.user?.updateDisplayName(
          authResult.user?.email?.replaceAll("@gmail.com", ""));

      bool hasPreviouslySignedIn = await firestore
          .collection("Users")
          .doc(authResult.user?.uid)
          .get()
          .then((value) => value.exists);

      if (!hasPreviouslySignedIn) {
        setProfileState();
        navigateToSetUpProfile();
      }

      // Return the user after a successful sign-in
    } catch (error) {
      if (error is PlatformException) {
        if (error.code == GoogleSignIn.kSignInCanceledError) {
          if (buildcontext.currentContext != null) {
            showCupertinoModalPopup(
                context: buildcontext.currentContext!,
                builder: (BuildContext popup) {
                  return const GoogleSignInCancelledPopUp();
                });
          }
        } else if (error.code == GoogleSignIn.kNetworkError) {
          if (buildcontext.currentContext != null) {
            showCupertinoModalPopup(
                context: buildcontext.currentContext!,
                builder: (BuildContext popup) {
                  return const GoogleSignInNetworkErrorPopUp();
                });
          }
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: grayscale[400],
                      side: BorderSide(color: grayscale[200] ?? Colors.black),
                      padding: const EdgeInsets.symmetric(vertical: 20)),
                  onPressed: () {
                    _signInWithGoogle();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/icons/Google.svg"),
                      const SizedBox(
                        width: 12,
                      ),
                      Text("Continue With Google",
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
