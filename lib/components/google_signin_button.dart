import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/google_auth_loading_popup.dart';
import 'package:galaxia/components/google_signin_cancelled_popup.dart';
import 'package:galaxia/components/google_signin_network_error_popup.dart';

import 'package:galaxia/providers/profile_setup_provider.dart';
import 'package:galaxia/screens/auth/profile_setup.dart';

import 'package:galaxia/theme/theme.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

enum GoogleSignInButtonType { icon, normal }

class SignInWithGoogleButton extends StatefulWidget {
  final GoogleSignInButtonType type;
  const SignInWithGoogleButton({Key? key, required this.type})
      : super(key: key);

  @override
  SignInWithGoogleButtonState createState() => SignInWithGoogleButtonState();
}

class SignInWithGoogleButtonState extends State<SignInWithGoogleButton> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  setProfileState() {
    Provider.of<ProfileSetupProvider>(context, listen: false)
        .setProfileSetup(false);
  }

  navigateToSetUpProfile() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const ProfileSetUp(),
    ));
  }

  openAuthCancelledPopUp() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext popup) {
          return const GoogleSignInCancelledPopUp();
        });
  }

  openAuthNetworkErrorPopUp() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext popup) {
          return const GoogleSignInNetworkErrorPopUp();
        });
  }

  final GlobalKey<NavigatorState> googleAuthLoadingPopUpKey =
      GlobalKey<NavigatorState>();

  openAuthLoadingPopUp() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext popup) {
          return GoogleAuthLoadingPopUp(
            key: googleAuthLoadingPopUpKey,
          );
        });
  }

  void closeAuthLoadingPopUp() {
    if (googleAuthLoadingPopUpKey.currentContext != null) {
      Navigator.pop(googleAuthLoadingPopUpKey.currentContext!);
    }
  }

  _signInWithGoogle() async {
    try {
      // Trigger the Google Sign In process
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        throw PlatformException(code: GoogleSignIn.kSignInCanceledError);
      }

      openAuthLoadingPopUp();
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

      closeAuthLoadingPopUp();

      await authResult.user?.updateDisplayName(
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
      closeAuthLoadingPopUp();
      if (error is PlatformException) {
        if (error.code == GoogleSignIn.kSignInCanceledError) {
          openAuthCancelledPopUp();
        } else if (error.code == GoogleSignIn.kNetworkError) {
          openAuthNetworkErrorPopUp();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return widget.type == GoogleSignInButtonType.normal
        ? OutlinedButton(
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
            ))
        : OutlinedButton(
            style: OutlinedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(24),
                foregroundColor: grayscale[600],
                side: BorderSide(color: grayscale[200] ?? Colors.black)),
            onPressed: () {
              _signInWithGoogle();
            },
            child: SvgPicture.asset(
              "assets/icons/Google.svg",
              fit: BoxFit.scaleDown,
              width: 20,
            ));
  }
}
