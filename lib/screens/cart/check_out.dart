import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/address_card.dart';
import 'package:galaxia/components/check_out_item_card.dart';
import 'package:galaxia/components/order_card.dart';
import 'package:galaxia/components/shimmer.dart';
import 'package:galaxia/screens/cart/choose_shipping_mode.dart';
import 'package:galaxia/screens/profile/add_new_address.dart';
import 'package:galaxia/store/address_book_state.dart';
import 'package:galaxia/store/app_state.dart';
import 'package:galaxia/store/galaxia_product.dart';

import 'package:galaxia/theme/theme.dart';

class CheckOut extends StatelessWidget {
  const CheckOut({Key? key}) : super(key: key);

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
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    "assets/icons/Dots Horizontal.svg",
                  ),
                ),
              ],
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
                "Check Out",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: width * 0.05),
              ),
            ),
          )),
      body: SafeArea(child:
          StoreBuilder<AppState>(builder: (galaxiastorecontext, galaxiastore) {
        AddressBookItem address =
            galaxiastore.state.addressBook.items.firstWhere(
          (element) => element.isDefault == true,
          orElse: () => AddressBookItem(
              id: "",
              uid: "",
              name: "",
              country: "",
              state: "",
              city: "",
              postalCode: "",
              line1: "",
              line2: "",
              isDefault: false),
        );
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width,
                      height: 2,
                      decoration: ShapeDecoration(
                          shape: StadiumBorder(), color: grayscale[200]),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      "Shipping Address",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: width * 0.04),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    galaxiastore.state.addressBook.items.isEmpty ||
                            address.id == ""
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0.0,
                                backgroundColor: grayscale[200],
                                foregroundColor: grayscale[400]),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AddNewAddress()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset("assets/icons/Plus.svg"),
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  "Add Address",
                                  style: TextStyle(
                                      color: grayscale[1000],
                                      fontSize: width * 0.032),
                                )
                              ],
                            ))
                        : AddressCard(
                            address: address,
                          ),
                    const SizedBox(
                      height: 32,
                    ),
                    Container(
                      width: width,
                      height: 2,
                      decoration: ShapeDecoration(
                          shape: StadiumBorder(), color: grayscale[200]),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Cart")
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .collection("Item")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Shimmer(
                            child: ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 4,
                                itemBuilder: (listContext, index) {
                                  return const Padding(
                                    padding: EdgeInsets.only(bottom: 24),
                                    child: OrderCardShimmer(),
                                  );
                                }),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            final Map<String, dynamic> data =
                                snapshot.data?.docs[index].data()
                                    as Map<String, dynamic>;

                            data.addEntries([
                              MapEntry("ID", snapshot.data?.docs[index].id)
                            ]);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: CheckOutItemCard(
                                  item: GalaxiaCartProduct.fromJson(data)),
                            );
                          },
                        );
                      },
                    ))
                  ],
                ),
              ),
            ),
            Container(
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
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Cart")
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.exists) {
                      return ElevatedButton(
                          onPressed: galaxiastore
                                  .state.addressBook.items.isEmpty
                              ? null
                              : () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ChooseShippingMode(
                                            total: snapshot.data?.get("Total"),
                                          )));
                                },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Continue To Payment",
                                style: TextStyle(color: primary[900]),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              SvgPicture.asset(
                                "assets/icons/Right Arrow.svg",
                                width: 16,
                                height: 16,
                              ),
                            ],
                          ));
                    } else {
                      return const SizedBox();
                    }
                  },
                )),
          ],
        );
      })),
    );
  }
}
