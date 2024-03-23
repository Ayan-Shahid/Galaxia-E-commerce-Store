import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/main.dart';
import 'package:galaxia/providers/profile_setup_provider.dart';

import 'package:galaxia/theme/theme.dart';

import 'package:provider/provider.dart';

class CreateNewPin extends StatefulWidget {
  const CreateNewPin({super.key});

  @override
  CreateNewPinState createState() => CreateNewPinState();
}

class CreateNewPinState extends State<CreateNewPin> {
  final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());
  final GlobalKey<CreateNewPinState> buildcontext = GlobalKey();

  FirebaseAuth auth = FirebaseAuth.instance;

  final List<TextEditingController> controllers =
      List.generate(4, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
    controllers[3].addListener(_onFourthDigitChanged);
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  setProfileState() {
    if (mounted) {
      Provider.of<ProfileSetupProvider>(context, listen: false)
          .setProfileSetup(true);
    }
  }

  goBack() {
    Navigator.of(context).pop();
  }

  submit() async {
    String pin =
        '${controllers[0].text}${controllers[1].text}${controllers[2].text}${controllers[3].text}';
    try {
      await galaxiaStorage.write(
          key: "${auth.currentUser?.uid} PIN", value: pin);

      setProfileState();
      goBack();
    } catch (error) {
      print(error);
    }

    // Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => SetFingerPrint(
    //           saveFirebaseUser: widget.submitUserToFirebase,
    //         )));
    // if (await auth.canCheckBiometrics) {
    //   List<BiometricType> biometrics = await auth.getAvailableBiometrics();
    //   if (biometrics.contains(BiometricType.face)) {
    //     Navigator.of(context).push(MaterialPageRoute(
    //         builder: (context) => SetFaceId(
    //               saveFirebaseUser: widget.submitUserToFirebase,
    //             )));
    //   }

    // }
  }

  void _onFourthDigitChanged() async {
    if (controllers[3].text.length == 1) {
      // Automatically submit input when 4 digits are entered
      submit();
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
              centerTitle: false,
              title: Text(
                "Create New Pin",
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(
              flex: 1,
            ),
            Text(
              "Add a PIN number to make your account more secure.",
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
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
            const Spacer(
              flex: 1,
            ),
            ElevatedButton(
                onPressed: submit,
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(width, width * 0.14)),
                child: Text(
                  "Continue",
                  style:
                      TextStyle(fontSize: width * 0.032, color: primary[900]),
                ))
          ],
        ),
      )),
    );
  }
}
