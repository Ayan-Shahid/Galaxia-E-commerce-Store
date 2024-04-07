import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/authenticate_form_button.dart';

import 'package:galaxia/main.dart';

import 'package:galaxia/screens/auth/register.dart';
import 'package:galaxia/store/app_state.dart';

import 'package:galaxia/theme/theme.dart';

class ConfirmDeleteAccount extends StatefulWidget {
  const ConfirmDeleteAccount({Key? key}) : super(key: key);

  @override
  ConfirmDeleteAccountState createState() => ConfirmDeleteAccountState();
}

class ConfirmDeleteAccountState extends State<ConfirmDeleteAccount> {
  final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());
  final FirebaseFunctions functions = FirebaseFunctions.instance;
  Reference storageReference = FirebaseStorage.instance.ref();
  bool pinError = false;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FormStates buttonState = FormStates.Default;
  final List<TextEditingController> controllers =
      List.generate(4, (index) => TextEditingController());

  goBack() {
    Navigator.of(context).pop();
  }

  deleteAccount() async {
    String stripeId = await firestore
        .collection("Users")
        .doc(auth.currentUser?.uid)
        .get()
        .then((value) => value.get("Stripe ID"));
    QuerySnapshot address = await firestore
        .collection("Address's")
        .where("ID", isEqualTo: auth.currentUser?.uid)
        .get();
    QuerySnapshot reviews = await firestore
        .collection("Review")
        .where("User ID", isEqualTo: auth.currentUser?.uid)
        .get();
    QuerySnapshot orders = await firestore
        .collection("Order")
        .where("User ID", isEqualTo: auth.currentUser?.uid)
        .get();
    List<DocumentSnapshot> ordersub = [];

    for (DocumentSnapshot element in orders.docs) {
      QuerySnapshot list = await firestore
          .collection("Order")
          .doc(element.id)
          .collection("Item")
          .get();
      ordersub.addAll(list.docs);
    }

    QuerySnapshot wishlist = await firestore
        .collection("Wish List")
        .doc(auth.currentUser?.uid)
        .collection("Item")
        .get();
    QuerySnapshot wallet = await firestore
        .collection("E-Wallet")
        .doc(auth.currentUser?.uid)
        .collection("Transaction")
        .get();
    QuerySnapshot cart = await firestore
        .collection("Cart")
        .doc(auth.currentUser?.uid)
        .collection("Item")
        .get();
    await firestore.runTransaction((transaction) async {
      for (QueryDocumentSnapshot element in address.docs) {
        transaction.delete(firestore.collection("Address's").doc(element.id));
      }
      for (QueryDocumentSnapshot element in reviews.docs) {
        transaction.delete(firestore.collection("Review").doc(element.id));
      }
      for (QueryDocumentSnapshot element in orders.docs) {
        for (DocumentSnapshot subelement in ordersub) {
          transaction.delete(firestore
              .collection("Order")
              .doc(element.id)
              .collection("Item")
              .doc(subelement.id));
        }
        transaction.delete(firestore.collection("Order").doc(element.id));
      }
      for (DocumentSnapshot element in wishlist.docs) {
        transaction.delete(firestore
            .collection("Wish List")
            .doc(auth.currentUser?.uid)
            .collection("Item")
            .doc(element.id));
      }
      for (DocumentSnapshot element in wallet.docs) {
        transaction.delete(firestore
            .collection("E-Wallet")
            .doc(auth.currentUser?.uid)
            .collection("Transaction")
            .doc(element.id));
      }
      for (DocumentSnapshot element in cart.docs) {
        transaction.delete(firestore
            .collection("Cart")
            .doc(auth.currentUser?.uid)
            .collection("Item")
            .doc(element.id));
      }
      transaction
          .delete(firestore.collection("Wish List").doc(auth.currentUser?.uid));
      transaction
          .delete(firestore.collection("E-Wallet").doc(auth.currentUser?.uid));
      transaction
          .delete(firestore.collection("Cart").doc(auth.currentUser?.uid));
      transaction
          .delete(firestore.collection("Users").doc(auth.currentUser?.uid));
    });
    await storageReference.child('${auth.currentUser!.uid}/').delete();

    await functions
        .httpsCallable("deleteStripeCustomer")
        .call({"id": stripeId});
  }

  submit() async {
    String pin =
        '${controllers[0].text}${controllers[1].text}${controllers[2].text}${controllers[3].text}';
    try {
      setState(() {
        buttonState = FormStates.Validating;
      });
      final PIN =
          await galaxiaStorage.read(key: "${auth.currentUser?.uid} PIN");
      if (pin == PIN) {
        if (auth.currentUser?.providerData.first.providerId ==
            GoogleAuthProvider().providerId) {
          await auth.currentUser
              ?.reauthenticateWithProvider(GoogleAuthProvider());
        } else {
          final email =
              await galaxiaStorage.read(key: "${auth.currentUser?.uid} Email");
          final password = await galaxiaStorage.read(
              key: "${auth.currentUser?.uid} Password");

          await auth.currentUser?.reauthenticateWithCredential(
              EmailAuthProvider.credential(email: email!, password: password!));
        }
        await deleteAccount();
        await galaxiaStorage.delete(key: "${auth.currentUser?.uid} PIN");
        await galaxiaStorage.delete(key: "${auth.currentUser?.uid} Email");

        await galaxiaStorage.delete(key: "${auth.currentUser?.uid} Password");

        setState(() {
          buttonState = FormStates.Success;
        });
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            buttonState = FormStates.Default;
          });
        });

        Future.delayed(Duration(seconds: 3), () async {
          await auth.currentUser?.delete();

          await auth.signOut();
          goBack();
        });
      } else {
        setState(() {
          buttonState = FormStates.Error;
          pinError = true;
        });
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            buttonState = FormStates.Default;
            pinError = false;
          });
        });
      }
    } catch (error) {
      print(error);

      setState(() {
        buttonState = FormStates.Error;
        pinError = true;
      });
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          buttonState = FormStates.Default;
          pinError = false;
        });
      });
    }
  }

  void _onFourthDigitChanged() async {
    if (controllers[3].text.length == 1) {
      // Automatically submit input when 4 digits are entered
      submit();
    }
  }

  @override
  void initState() {
    super.initState();
    controllers[3].addListener(_onFourthDigitChanged);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return StoreBuilder<AppState>(builder: (galaxiastorecontext, galaxiastore) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(52),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: AppBar(
                centerTitle: false,
                title: Text(
                  "Enter Your Pin",
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Enter your pin to change your password!",
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
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
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
                  const SizedBox(
                    height: 24,
                  ),
                  Visibility(
                    visible: pinError,
                    child: Text(
                      "Invalid PIN Try Again!",
                      style:
                          TextStyle(fontSize: width * 0.036, color: error[500]),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              )),
              AuthenticateFormButton(
                  formState: buttonState, title: "Continue", onSubmit: submit)
            ],
          ),
        )),
      );
    });
  }
}
