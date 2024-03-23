import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/google_signin_cancelled_popup.dart';
import 'package:galaxia/components/google_signin_network_error_popup.dart';

import 'package:galaxia/providers/profile_setup_provider.dart';
import 'package:galaxia/screens/auth/profile_setup.dart';

import 'package:galaxia/theme/theme.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class SignInWithGoogleButton extends StatefulWidget {
  const SignInWithGoogleButton({Key? key}) : super(key: key);

  @override
  SignInWithGoogleButtonState createState() => SignInWithGoogleButtonState();
}

class SignInWithGoogleButtonState extends State<SignInWithGoogleButton> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GlobalKey<SignInWithGoogleButtonState> buildcontext = GlobalKey();

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
    return OutlinedButton(
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
