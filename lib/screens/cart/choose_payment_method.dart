import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/authenticate_form_button.dart';
import 'package:galaxia/components/choose_payment_method_card.dart';
import 'package:galaxia/components/e_wallet_payment_card.dart';
import 'package:galaxia/screens/add_new_bank_card.dart';
import 'package:galaxia/screens/auth/register.dart';
import 'package:galaxia/screens/cart/confirm_payment.dart';
import 'package:galaxia/store/app_state.dart';
import 'package:galaxia/theme/theme.dart';

class ChoosePaymentMethod extends StatefulWidget {
  final double amount;
  const ChoosePaymentMethod({Key? key, required this.amount}) : super(key: key);

  @override
  ChoosePaymentMethodState createState() => ChoosePaymentMethodState();
}

class ChoosePaymentMethodState extends State<ChoosePaymentMethod> {
  FirebaseFunctions functions = FirebaseFunctions.instance;
  String? paymentIntentClientSecret;
  FormStates buttonState = FormStates.Default;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  getPaymentIntentSecret(double amount) async {
    try {
      String customerId = await firestore
          .collection("Users")
          .doc(auth.currentUser?.uid)
          .get()
          .then((value) => value.get("Stripe ID"));
      String secret = await functions
          .httpsCallable("createStripePaymentIntent")
          .call({
        "amount": (amount * 100).round(),
        "customer": customerId
      }).then((value) => value.data);

      setState(() {
        paymentIntentClientSecret = secret;
      });
    } catch (e) {
      print(e);
    }
  }

  goToConfirmPayment(String paymentMethodId) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ConfirmPayment(
              paymentIntentClientSecret: paymentMethodId == "E-Wallet"
                  ? paymentMethodId
                  : paymentIntentClientSecret,
              paymentMethodId: paymentMethodId,
            )));
  }

  submit(double amount, String paymentMethodId) async {
    try {
      setState(() {
        buttonState = FormStates.Validating;
      });
      if (paymentMethodId != "E-Wallet") {
        await getPaymentIntentSecret(amount);
      }
      setState(() {
        buttonState = FormStates.Success;
        Future.delayed(const Duration(seconds: 2), () {
          buttonState = FormStates.Default;
        });
      });
      goToConfirmPayment(paymentMethodId);
    } catch (e) {
      print(e);
      setState(() {
        buttonState = FormStates.Error;
        Future.delayed(const Duration(seconds: 2), () {
          buttonState = FormStates.Default;
        });
      });
    }
  }

  int? selected;
  select(int index) {
    setState(() {
      selected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(width * 0.16),
          child: Container(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
            child: AppBar(
              flexibleSpace: Container(color: grayscale[100]),
              centerTitle: false,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AddNewBankCard()));
                    },
                    icon: SvgPicture.asset("assets/icons/Plus.svg"))
              ],
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: SvgPicture.asset(
                    "assets/icons/Left Arrow.svg",
                    width: 32,
                    height: 32,
                  )),
              title: Text(
                "Payment Method",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: width * 0.05),
              ),
            ),
          )),
      body:
          StoreBuilder<AppState>(builder: (galaxiastorecontext, galaxiastore) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: EWalletPaymentCard(
                  onPressed: () {
                    setState(() {
                      selected = null;
                    });
                  },
                  selected: selected == null,
                  price: widget.amount),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: galaxiastore.state.paymentMethods.items.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/illustrations/No Data.svg",
                            width: width,
                          ),
                          SizedBox(
                            width: width * 0.6,
                            child: Text("Your have no payment methods!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: width * 0.05)),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            width: width * 0.6,
                            child: Text(
                                "You don't have any payment methods saved!",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: width * 0.028)),
                          ),
                        ],
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          child: ChoosePaymentMethodCard(
                              onPressed: () => select(index),
                              price: widget.amount,
                              icon: galaxiastore
                                  .state.paymentMethods.items[index].type!,
                              method: galaxiastore
                                  .state.paymentMethods.items[index],
                              selected: selected == index ? true : false),
                        ),
                        itemCount:
                            galaxiastore.state.paymentMethods.items.length,
                      ),
              ),
            ),
            Visibility(
              visible: galaxiastore.state.paymentMethods.items.isNotEmpty,
              child: Container(
                  padding: const EdgeInsets.only(
                      top: 24, left: 24, right: 24, bottom: 24),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              color: grayscale[300] ?? Colors.black26)),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32))),
                  child: AuthenticateFormButton(
                      formState: buttonState,
                      onSubmit: () {
                        submit(
                            widget.amount,
                            selected != null
                                ? galaxiastore
                                    .state.paymentMethods.items[selected!].id!
                                : "E-Wallet");
                      },
                      title: "Confirm Payment")),
            )
          ],
        );
      }),
    );
  }
}
