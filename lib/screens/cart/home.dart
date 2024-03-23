import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/cart_item.dart';
import 'package:galaxia/components/order_card.dart';
import 'package:galaxia/components/shimmer.dart';
import 'package:galaxia/screens/cart/check_out.dart';

import 'package:galaxia/store/galaxia_product.dart';

import 'package:galaxia/theme/theme.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Container(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
            child: AppBar(
              flexibleSpace: Container(color: grayscale[100]),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    "assets/icons/Search.svg",
                  ),
                ),
              ],
              centerTitle: false,
              leading: SvgPicture.asset("assets/icons/Logo.svg"),
              title: const Text(
                "My Cart",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Cart")
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .collection("Item")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Shimmer(
                    child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 4,
                        itemBuilder: (listContext, index) {
                          return const Padding(
                              padding: EdgeInsets.only(bottom: 24),
                              child: OrderCardShimmer());
                        }),
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty ||
                    snapshot.hasError) {
                  return Column(
                    children: [
                      SizedBox(
                        width: width,
                        child: SvgPicture.asset(
                          "assets/illustrations/No Data.svg",
                          width: width * 0.8,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.6,
                        child: Text("Your cart is empty!",
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
                        child: Text("You don't have any items in your cart!",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: width * 0.028)),
                      ),
                    ],
                  );
                }

                final List<DocumentSnapshot> cartData = snapshot.data!.docs;

                return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: cartData.length,
                    itemBuilder: (listContext, index) {
                      Map<String, dynamic> data =
                          cartData[index].data() as Map<String, dynamic>;
                      data.addEntries([MapEntry("ID", cartData[index].id)]);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child:
                            CartItem(item: GalaxiaCartProduct.fromJson(data)),
                      );
                    });
              },
            )),
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Cart")
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.exists) {
                    return Container(
                      padding: const EdgeInsets.all(24),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  color: grayscale[300] ?? Colors.black26)),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32))),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Price",
                                style: TextStyle(color: grayscale[500]),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "\$${(snapshot.data!.get("Total") as num).toStringAsFixed(2)}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 24,
                          ),
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .push(MaterialPageRoute(
                                            builder: (context) =>
                                                const CheckOut()));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/Bag Filled.svg",
                                        width: 16,
                                        height: 16,
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Text(
                                        "Check Out",
                                        style: TextStyle(color: primary[900]),
                                      )
                                    ],
                                  )))
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                })
          ],
        ),
      ),
    );
  }
}
