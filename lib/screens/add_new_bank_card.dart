import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/authenticate_form_button.dart';
import 'package:galaxia/components/bank_card.dart';
import 'package:galaxia/components/card_number_input.dart';
import 'package:galaxia/components/check_box.dart';
import 'package:galaxia/components/cvc_input.dart';
import 'package:galaxia/components/expiry_month_input.dart';
import 'package:galaxia/components/expiry_year_input.dart';
import 'package:galaxia/screens/auth/register.dart';
import 'package:galaxia/store/app_state.dart';
import 'package:galaxia/store/galaxia_store.dart';
import 'package:galaxia/store/payment_methods_state.dart';
import 'package:galaxia/theme/theme.dart';
import 'package:redux/redux.dart';
import 'package:stripe_sdk/stripe_sdk.dart';

class AddNewBankCard extends StatefulWidget {
  const AddNewBankCard({super.key});

  @override
  AddNewBankCardState createState() => AddNewBankCardState();
}

class AddNewBankCardState extends State<AddNewBankCard> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<AddNewBankCardState> buildcontext = GlobalKey();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? cardNumberErrorString;
  String? cvcErrorString;
  String? expiryMonthErrorString;
  String? expiryYearErrorString;

  toggleDefault() {
    setState(() {
      isDefault = !isDefault;
    });
  }

  bool isDefault = true;

  FormStates formState = FormStates.Default;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFunctions cloudFunctions = FirebaseFunctions.instance;
  final TextEditingController cardNumberInputController =
      TextEditingController();
  final TextEditingController cardNameInputController = TextEditingController();
  final TextEditingController expiryYearInputController =
      TextEditingController();
  final TextEditingController expiryMonthInputController =
      TextEditingController();
  final TextEditingController cvvInputController = TextEditingController();

  String cardNameText = "Card Name";
  String cardExpiryDateYearText = "2022";
  String cardExpiryDateMonthText = "12";

  Future<String?> createStripePaymentMethod(
      String number, String expMonth, String expYear, String cvc) async {
    return await Stripe.instance.api.createPaymentMethod({
      "type": "card",
      "card": {
        "number": number,
        "exp_month": expMonth,
        "exp_year": expYear,
        "cvc": cvc,
      },
      "billing_details": {
        "name": cardNameInputController.text,
        "email": auth.currentUser?.email,
        "phone": auth.currentUser?.phoneNumber
      }
    }).then((value) => value["id"]);
  }

  createPaymentMethod() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        formState = FormStates.Validating;
      });
      try {
        String? paymentMethod = await createStripePaymentMethod(
            cardNumberInputController.text,
            expiryMonthInputController.text,
            expiryYearInputController.text,
            cvvInputController.text);

        String stripeId = await firestore
            .collection("Users")
            .doc(auth.currentUser!.uid)
            .get()
            .then((value) => value.get("Stripe ID"));

        final method = await FirebaseFunctions.instance
            .httpsCallable("attachStripePaymentMethod")
            .call({"id": paymentMethod, "customer": stripeId});
        if (isDefault) {
          await FirebaseFunctions.instance
              .httpsCallable("setStripeCustomerDefaultPaymentMethod")
              .call({"payment_method_id": paymentMethod, "id": stripeId});
        }
        galaxiaStore.dispatch((Store<AppState> store) {
          store.dispatch(PaymentMethodsStateAction(
              type: PaymentMethodsStateActions.add,
              payload: PaymentMethodItem(
                  isDefault: isDefault,
                  name: cardNameInputController.text,
                  expMonth: expiryMonthInputController.text,
                  expYear: expiryYearInputController.text,
                  id: method.data["id"],
                  last4: method.data["card"]["last4"],
                  type: method.data["card"]["brand"])));
        });

        setState(() {
          formState = FormStates.Success;
          Future.delayed(const Duration(seconds: 4), () {
            formState = FormStates.Default;
            cardNumberErrorString = null;
            cvcErrorString = null;
            expiryMonthErrorString = null;
            expiryYearErrorString = null;
            Navigator.of(context).pop();
          });
        });
      } on FirebaseFunctionsException {
        setState(() {
          formState = FormStates.Error;
        });
      } on StripeApiException catch (error) {
        setState(() {
          formState = FormStates.Error;
          Future.delayed(const Duration(seconds: 4), () {
            formState = FormStates.Default;
            cardNumberErrorString = null;
            cvcErrorString = null;
            expiryMonthErrorString = null;
            expiryYearErrorString = null;
          });
          if (error.error.code == "incorrect_number" ||
              error.error.code == "invalid_number") {
            cardNumberErrorString = "Please enter a valid card number!";
          } else if (error.error.code == "incorrect_cvc" ||
              error.error.code == "invalid_cvc") {
            cvcErrorString = "Please enter a valid CVC!";
          } else if (error.error.code == "invalid_expiry_month") {
            expiryMonthErrorString = "Please enter a valid expiry month!";
          } else if (error.error.code == "invalid_expiry_year") {
            expiryMonthErrorString = "Please enter a valid expiry year!";
          }
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(width * 0.16),
          child: Container(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: AppBar(
              flexibleSpace: Container(color: grayscale[100]),
              centerTitle: false,
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
                "Add New Card",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: width * 0.05),
              ),
            ),
          )),
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BankCard(
              cardHolderName: auth.currentUser?.displayName ?? "Card Name",
              cardName: cardNameText,
              expiryDateMonth: cardExpiryDateMonthText,
              expiryDateYear: cardExpiryDateYearText,
            ),
            const SizedBox(
              height: 24,
            ),
            Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Card Name",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: width * 0.034),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      controller: cardNameInputController,
                      onChanged: (value) {
                        setState(() {
                          cardNameText = value;
                        });
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your card number!";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 24, right: 20),
                            child: SvgPicture.asset(
                                "assets/icons/User Filled.svg"),
                          ),
                          labelText: "Card Name"),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      "Card Number",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: width * 0.034),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CardNumberInput(
                      controller: cardNumberInputController,
                      error: cardNumberErrorString,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Expiry Month",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: width * 0.034),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            ExpiryMonthInput(
                              controller: expiryMonthInputController,
                              error: expiryMonthErrorString,
                              onChange: (value) {
                                setState(() {
                                  cardExpiryDateMonthText = value;
                                });
                              },
                            ),
                          ],
                        )),
                        const SizedBox(
                          width: 24,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Expiry Year",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: width * 0.034),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            ExpiryYearInput(
                              controller: expiryYearInputController,
                              error: expiryYearErrorString,
                              onChange: (value) {
                                setState(() {
                                  cardExpiryDateYearText = value;
                                });
                              },
                            ),
                          ],
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      "CVC",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: width * 0.034),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CVCInput(
                      controller: cvvInputController,
                      error: cvcErrorString,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        CheckBox(
                          selected: isDefault,
                          onTap: toggleDefault,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child: Text(
                          "Make this the default payment method",
                          softWrap: true,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.032),
                        ))
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    AuthenticateFormButton(
                        formState: formState,
                        title: "Add Card",
                        onSubmit: createPaymentMethod)
                  ],
                ))
          ],
        ),
      )),
    );
  }
}
