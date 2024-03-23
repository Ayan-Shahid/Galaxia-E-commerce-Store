import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/authenticate_form_button.dart';
import 'package:galaxia/components/order_successful_popup.dart';
import 'package:galaxia/main.dart';
import 'package:galaxia/providers/local_notification_service.dart';
import 'package:galaxia/screens/auth/register.dart';
import 'package:galaxia/store/app_state.dart';

import 'package:galaxia/store/galaxia_product.dart';

import 'package:galaxia/theme/theme.dart';

import 'package:stripe_sdk/stripe_sdk.dart';
import 'package:uuid/uuid.dart';

class ConfirmPayment extends StatefulWidget {
  const ConfirmPayment({
    Key? key,
    this.paymentIntentClientSecret,
    this.paymentMethodId,
  }) : super(key: key);
  final String? paymentIntentClientSecret;
  final String? paymentMethodId;

  @override
  ConfirmPaymentState createState() => ConfirmPaymentState();
}

class ConfirmPaymentState extends State<ConfirmPayment> {
  final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  showPopUp(List<GalaxiaCartProduct> item, num amount, String paymentMethod,
      DateTime date, String transactionId) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) => OrderSuccessfulPopup(
              item: item,
              amount: amount,
              paymentMethod: paymentMethod,
              date: date,
              transactionId: transactionId,
            ));
  }

  num cartTotal = 0;
  FormStates buttonState = FormStates.Default;
  final List<TextEditingController> controllers =
      List.generate(4, (index) => TextEditingController());
  confirmPayment() async {
    if (widget.paymentIntentClientSecret != null &&
        widget.paymentIntentClientSecret != "") {
      Map<String, dynamic> paymentIntent = {};
      if (widget.paymentMethodId != "E-Wallet") {
        paymentIntent = await Stripe.instance
            .confirmPayment(widget.paymentIntentClientSecret!, context,
                paymentMethodId: widget.paymentMethodId)
            .then((value) => (value));
      }
      Timestamp dateCreated = Timestamp.now();
      final DocumentReference cartref =
          firestore.collection("Cart").doc(auth.currentUser?.uid);
      final List<DocumentSnapshot> items =
          await cartref.collection("Item").get().then((value) => value.docs);

      final String transactionId = Uuid().v4();
      await firestore.runTransaction((transaction) async {
        final DocumentSnapshot cart = await transaction.get(cartref);
        final DocumentSnapshot wallet = await transaction
            .get(firestore.collection("E-Wallet").doc(auth.currentUser?.uid));
        setState(() {
          cartTotal = cart.get("Total");
        });
        final DocumentReference document = firestore.collection("Order").doc();
        transaction.set(
            document,
            ({
              "User ID": auth.currentUser?.uid,
              "Transaction ID": widget.paymentMethodId != "E-Wallet"
                  ? paymentIntent["id"]
                  : transactionId,
              "Payment Method": widget.paymentMethodId == "E-Wallet"
                  ? "E-Wallet"
                  : paymentIntent["payment_method"],
              "Amount": cartTotal,
              "Date": dateCreated,
            }));

        for (DocumentSnapshot element in items) {
          final Map<String, dynamic> order =
              element.data() as Map<String, dynamic>;
          order.addEntries([
            MapEntry("Status", Random().nextBool() ? "Completed" : "On Going")
          ]);
          transaction.set(document.collection("Item").doc(), order);
        }
        for (DocumentSnapshot element in items) {
          if (widget.paymentMethodId == "E-Wallet") {
            transaction.set(
                firestore
                    .collection("E-Wallet")
                    .doc(auth.currentUser?.uid)
                    .collection("Transaction")
                    .doc(),
                {
                  "Date": Timestamp.now(),
                  "Title": element.get("Name"),
                  "Image": element.get("Image"),
                  "Price": element.get("Price") * element.get("Quantity"),
                  "Type": "Order"
                });
            transaction.update(
                firestore.collection("E-Wallet").doc(auth.currentUser?.uid), {
              "Balance": wallet.get("Balance") -
                  (element.get("Price") * element.get("Quantity")),
            });
          }
          transaction.delete(cartref.collection("Item").doc(element.id));
        }

        transaction.delete(cartref);
      });

      showPopUp(
          items
              .map((e) =>
                  GalaxiaCartProduct.fromJson(e.data() as Map<String, dynamic>))
              .toList(),
          cartTotal,
          widget.paymentMethodId == "E-Wallet" ? "E-Wallet" : "Card",
          dateCreated.toDate(),
          transactionId);
    }
  }

  bool pinError = false;
  submit() async {
    String pin =
        '${controllers[0].text}${controllers[1].text}${controllers[2].text}${controllers[3].text}';
    if (pin.length == 4) {
      try {
        setState(() {
          buttonState = FormStates.Validating;
        });
        final PIN =
            await galaxiaStorage.read(key: "${auth.currentUser?.uid} PIN");
        if (pin == PIN) {
          await confirmPayment();
          setState(() {
            buttonState = FormStates.Success;
          });
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              buttonState = FormStates.Default;
            });
          });
          LocalNotificationService().showNotification(
              title: "Order Successful!",
              body: "Your order is placed successfully!");
        } else {
          setState(() {
            pinError = true;
            Future.delayed(const Duration(seconds: 10), () {
              pinError = false;
            });
            buttonState = FormStates.Error;
          });
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              buttonState = FormStates.Default;
            });
          });
        }
      } catch (error) {
        print(error);
        setState(() {
          buttonState = FormStates.Error;
        });
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              buttonState = FormStates.Default;
            });
          }
        });
      }
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
                  "Confirm Payment",
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
                    "Enter your pin to confirm the payment!",
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
                        width: width * 0.17,
                        height: width * 0.17,
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
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.06),
                          decoration: const InputDecoration(
                            counterText: "",
                          ),
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
                formState: buttonState,
                onSubmit: submit,
                title: "Continue",
              )
            ],
          ),
        )),
      );
    });
  }
}
