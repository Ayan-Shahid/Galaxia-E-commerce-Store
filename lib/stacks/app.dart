import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:galaxia/components/bottom_bar.dart';

import 'package:galaxia/providers/profile_setup_provider.dart';
import 'package:galaxia/screens/auth/profile_setup.dart';

import 'package:galaxia/views/cart.dart';
import 'package:galaxia/store/address_book_state.dart';

import 'package:galaxia/store/galaxia_store.dart';

import 'package:galaxia/store/payment_methods_state.dart';

import 'package:galaxia/views/home.dart';
import 'package:galaxia/views/orders.dart';
import 'package:galaxia/views/profile.dart';
import 'package:galaxia/views/wallet.dart';

import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:galaxia/store/app_state.dart' as app_state;

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseFunctions functions = FirebaseFunctions.instance;

  List<Widget> screens = [
    const Home(),
    const Cart(),
    const Orders(),
    const Wallet(),
    const Profile()
  ];
  int current = 0;
  navigate(int value) {
    setState(() {
      current = value;
    });
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAddressBook();

    getPaymentMethods();

    getUserAuthStatus();
  }

  getPaymentMethods() async {
    galaxiaStore.dispatch((Store<app_state.AppState> store) {
      store.dispatch(
          PaymentMethodsStateAction(type: PaymentMethodsStateActions.clear));
    });
    try {
      bool exists = await firestore
          .collection("Users")
          .doc(auth.currentUser?.uid)
          .get()
          .then((value) => value.exists);
      if (exists == false) return;
      String customer = await firestore
          .collection("Users")
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) => value.get("Stripe ID"));
      String? defaultPaymentMethod = await functions
          .httpsCallable("getStripeCustomerDefaultPaymentMethod")
          .call({"id": customer}).then((value) =>
              value.data["invoice_settings"]["default_payment_method"]);
      await functions
          .httpsCallable("retreiveStripePaymentMethod")
          .call({"id": customer}).then((value) {
        value.data.forEach((item) {
          galaxiaStore.dispatch((Store<app_state.AppState> store) {
            bool isDefault = false;
            if (defaultPaymentMethod == null) {
              isDefault = false;
            } else if (defaultPaymentMethod == item["id"]) {
              isDefault = true;
            }

            store.dispatch(PaymentMethodsStateAction(
                type: PaymentMethodsStateActions.add,
                payload: PaymentMethodItem(
                    isDefault: isDefault,
                    name: item["billing_details"]["name"],
                    expMonth: item["card"]["exp_month"].toString(),
                    expYear: item["card"]["exp_year"].toString(),
                    id: item["id"],
                    last4: item["card"]["last4"],
                    type: item["card"]["brand"])));
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }

  setProfileStatus(bool value) {
    if (mounted) {
      Provider.of<ProfileSetupProvider>(context, listen: false)
          .setProfileSetup(value);
    }
  }

  getUserAuthStatus() async {
    try {
      bool hasPreviouslySignedIn = await firestore
          .collection("Users")
          .doc(auth.currentUser?.uid)
          .get()
          .then((value) {
        return value.exists;
      });
      setProfileStatus(hasPreviouslySignedIn);
    } catch (e) {
      print(e);
    }
  }

  getAddressBook() async {
    galaxiaStore.dispatch((Store<app_state.AppState> store) {
      store.dispatch(
          AddressBookStateAction(type: AddressBookStateActions.clear));
    });
    try {
      QuerySnapshot inventory = await firestore
          .collection("Address's")
          .where("ID", isEqualTo: auth.currentUser?.uid)
          .get();
      for (var document in inventory.docs) {
        String? id = document.get("ID");

        String? name = document.get("Name");
        String? country = document.get("Country");
        String? city = document.get("City");

        String? state = document.get("State");

        String? postalCode = document.get("Postal Code");

        String? line1 = document.get("Line 1");
        String? line2 = document.get("Line 2");
        bool isDefault = document.get("Is Default");

        galaxiaStore.dispatch((Store<app_state.AppState> store) {
          store.dispatch(AddressBookStateAction(
              type: AddressBookStateActions.add,
              payload: AddressBookItem(
                  id: id,
                  uid: document.id,
                  name: name,
                  country: country,
                  state: state,
                  city: city,
                  postalCode: postalCode,
                  line1: line1,
                  line2: line2,
                  isDefault: isDefault)));
        });
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          Provider.of<ProfileSetupProvider>(context).hasCompletedProfileSetup
              ? BottomBar(
                  onChange: (value) => navigate(value),
                )
              : null,
      body: Provider.of<ProfileSetupProvider>(context).hasCompletedProfileSetup
          ? screens[current]
          : const ProfileSetUp(),
    );
  }
}
