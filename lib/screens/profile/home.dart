import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/avatar_picker.dart';
import 'package:galaxia/components/profile_list_button.dart';
import 'package:galaxia/main.dart';

import 'package:galaxia/screens/profile/address.dart';
import 'package:galaxia/screens/profile/confirm_delete_account.dart';
import 'package:galaxia/screens/profile/edit_profile.dart';
import 'package:galaxia/screens/profile/payment.dart';
import 'package:galaxia/screens/profile/security.dart';
import 'package:galaxia/theme/theme.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Reference storageReference = FirebaseStorage.instance.ref();
  FirebaseFunctions functions = FirebaseFunctions.instance;

  confirmDeletion() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ConfirmDeleteAccount()));
  }

  deleteAccount() async {
    try {
      WriteBatch batch = firestore.batch(); // Initialize a batch

      String stripeId = await firestore
          .collection("Users")
          .doc(auth.currentUser?.uid)
          .get()
          .then((value) => value.get("Stripe ID"));

      await functions
          .httpsCallable("deleteStripeCustomer")
          .call({"id": stripeId});
      await firestore.collection("Users").doc(auth.currentUser?.uid).delete();
      QuerySnapshot address = await firestore.collection("Address's").get();

      for (QueryDocumentSnapshot element in address.docs) {
        if (element.get("ID") == auth.currentUser?.uid) {
          batch.delete(firestore.collection("Address's").doc(element.id));
        }
      }

      QuerySnapshot order = await firestore.collection("Orders").get();

      for (QueryDocumentSnapshot element in order.docs) {
        if (element.get("User ID") == auth.currentUser?.uid) {
          batch.delete(firestore.collection("Orders").doc(element.id));
        }
      }
      await batch.commit();

      storageReference.child('${auth.currentUser!.uid}/').delete();
      await galaxiaStorage.delete(key: "${auth.currentUser?.uid} Email");
      await galaxiaStorage.delete(key: "${auth.currentUser?.uid} Password");

      confirmDeletion();
    } catch (e) {
      print(e);
    }
  }

  updatePhoto(File? file) async {
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      // contentType: 'image/png',
      customMetadata: {'picked-file-path': file!.path},
    );
    TaskSnapshot downloadUrl = await storageReference
        .child('${auth.currentUser!.uid}/')
        .putData(await file.readAsBytes(), metadata);

    String url = await downloadUrl.ref.getDownloadURL();
    auth.currentUser?.updatePhotoURL(url);
    firestore
        .collection("Users")
        .doc(auth.currentUser?.uid)
        .set({"Avatar": url}, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(width * 0.2),
          child: Container(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
            child: AppBar(
              flexibleSpace: Container(color: grayscale[100]),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    "assets/icons/Dots Horizontal.svg",
                  ),
                ),
              ],
              centerTitle: false,
              leading: SvgPicture.asset("assets/icons/Logo.svg"),
              title: Text(
                "Profile",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: width * 0.05),
              ),
            ),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  StreamBuilder<User?>(
                    stream: auth.userChanges(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const AvatarPickerLoading();
                      }
                      return AvatarPicker(
                        url: snapshot.data?.photoURL,
                        onChange: (file) => updatePhoto(file),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    auth.currentUser?.displayName ?? "User",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: width * 0.06),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "+92 123 03412 23",
                    style: TextStyle(fontSize: width * 0.03),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: width,
                height: 2,
                decoration: ShapeDecoration(
                    shape: const StadiumBorder(), color: grayscale[200]),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            ProfileListButton(
              name: "Edit Profile",
              icon: "User Filled",
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (context) => const EditProfile()));
              },
            ),
            ProfileListButton(
                name: "Address",
                icon: "Location",
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(builder: (context) => const Address()));
                }),
            ProfileListButton(
              name: "Notification",
              icon: "Bell",
              onPressed: () {},
            ),
            ProfileListButton(
              name: "Payment",
              icon: "Wallet Filled",
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (context) => const Payment()));
              },
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: width,
                height: 2,
                decoration: ShapeDecoration(
                    shape: const StadiumBorder(), color: grayscale[200]),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            ProfileListButton(
              name: "Security",
              icon: "Security",
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (context) => const Security()));
              },
            ),
            ProfileListButton(
              name: "Privacy Policy",
              icon: "Lock",
              onPressed: () {},
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: width,
                height: 2,
                decoration: ShapeDecoration(
                    shape: const StadiumBorder(), color: grayscale[200]),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              width: width,
              child: TextButton(
                  style: TextButton.styleFrom(
                      shape: const ContinuousRectangleBorder(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 4),
                      foregroundColor: error[300]),
                  onPressed: () {
                    auth.signOut();
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/Log Out.svg",
                            color: error[300],
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Text(
                            "Log Out",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: error[300]),
                          )
                        ],
                      ),
                    ],
                  )),
            ),
            SizedBox(
              width: width,
              child: TextButton(
                  style: TextButton.styleFrom(
                      shape: const ContinuousRectangleBorder(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 4),
                      foregroundColor: error[300]),
                  onPressed: deleteAccount,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/Trash.svg",
                            color: error[300],
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Text(
                            "Delete Account",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: error[300]),
                          )
                        ],
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
