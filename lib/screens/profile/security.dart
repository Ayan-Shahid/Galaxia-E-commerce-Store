import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/switch.dart';
import 'package:galaxia/screens/auth/create_new_password.dart';
import 'package:galaxia/screens/security/change_pin.dart';
import 'package:galaxia/screens/security/verify_pin.dart';
import 'package:galaxia/theme/theme.dart';

class Security extends StatefulWidget {
  const Security({Key? key}) : super(key: key);

  @override
  SecurityState createState() => SecurityState();
}

class SecurityState extends State<Security> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  navigateToVerifyPin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const VerifyPin()));
  }

  navigateToChangePassword() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CreateNewPassword(
              onSubmit: (password) => changeGooglePassword(password),
            )));
  }

  goBack() {
    Navigator.of(context).pop();
  }

  changeGooglePassword(String password) async {
    try {
      await auth.currentUser?.updatePassword(password);
      goBack();
    } catch (e) {
      print(e);
    }
  }

  changePassword() async {
    if (auth.currentUser?.providerData.first.providerId ==
        GoogleAuthProvider().providerId) {
      await auth.currentUser?.reauthenticateWithProvider(GoogleAuthProvider());
      navigateToChangePassword();
    } else {
      navigateToVerifyPin();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(width * 0.2),
          child: Container(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
            child: AppBar(
              flexibleSpace: Container(
                color: grayscale[100],
              ),
              centerTitle: false,
              title: Text("Security",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: width * 0.048)),
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: SvgPicture.asset(
                    "assets/icons/Left Arrow.svg",
                    width: width * 0.08,
                  )),
            ),
          )),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Remember Me",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                GalaxiaSwitch()
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Face ID", style: TextStyle(fontWeight: FontWeight.bold)),
                GalaxiaSwitch()
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Fingerprint",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                GalaxiaSwitch()
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ChangePin()));
                },
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(width, width * 0.14),
                    elevation: 0.0,
                    foregroundColor: grayscale[1000],
                    backgroundColor: grayscale[200]),
                child: const Text(
                  "Change PIN",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(
                onPressed: changePassword,
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(width, width * 0.14),
                    elevation: 0.0,
                    foregroundColor: grayscale[1000],
                    backgroundColor: grayscale[200]),
                child: const Text(
                  "Change Password",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))
          ],
        ),
      )),
    );
  }
}
