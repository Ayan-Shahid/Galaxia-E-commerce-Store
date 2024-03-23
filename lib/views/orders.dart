import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'package:galaxia/components/order_card.dart';
import 'package:galaxia/components/shimmer.dart';

import 'package:galaxia/store/galaxia_product.dart';
import 'package:galaxia/theme/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});
  @override
  OrdersState createState() => OrdersState();
}

class OrdersState extends State<Orders> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<List<DocumentSnapshot>> fetchCompletedOrders() async {
    try {
      final QuerySnapshot orders = await firestore
          .collection("Order")
          .where("User ID", isEqualTo: auth.currentUser?.uid)
          .get();
      List<DocumentSnapshot> items = [];
      for (DocumentSnapshot element in orders.docs) {
        final QuerySnapshot sublist = await element.reference
            .collection("Item")
            .where("Status", isEqualTo: "Completed")
            .get();
        items.addAll(sublist.docs);
      }
      return items;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<DocumentSnapshot>> fetchOnGoingOrders() async {
    try {
      final QuerySnapshot orders = await firestore
          .collection("Order")
          .where("User ID", isEqualTo: auth.currentUser?.uid)
          .get();
      List<DocumentSnapshot> items = [];
      for (DocumentSnapshot element in orders.docs) {
        final QuerySnapshot sublist = await element.reference
            .collection("Item")
            .where("Status", isEqualTo: "On Going")
            .get();
        items.addAll(sublist.docs);
      }
      return items;
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(width * 0.34),
              child: Container(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
                child: AppBar(
                  bottom: TabBar(
                      overlayColor: MaterialStatePropertyAll(primary[200]),
                      indicatorColor: primary[500],
                      indicatorSize: TabBarIndicatorSize.tab,
                      unselectedLabelColor: grayscale[500],
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.spaceMono().fontFamily),
                      unselectedLabelStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: GoogleFonts.spaceMono().fontFamily),
                      labelColor: primary[500],
                      dividerColor: grayscale[200],
                      tabs: const [
                        Tab(
                          text: "On Going",
                        ),
                        Tab(
                          text: "Completed",
                        )
                      ]),
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
                    "My Orders",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )),
          body: SafeArea(
            child: TabBarView(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Expanded(
                      child: FutureBuilder<List<DocumentSnapshot>>(
                          future: fetchOnGoingOrders(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Shimmer(
                                child: ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24),
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
                            if (snapshot.data!.isEmpty ||
                                snapshot.hasError ||
                                !snapshot.hasData) {
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
                                    child: Text("You don’t have any orders yet",
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
                                        "You don’t have any ongoing orders at this time",
                                        textAlign: TextAlign.center,
                                        style:
                                            TextStyle(fontSize: width * 0.028)),
                                  ),
                                ],
                              );
                            }
                            return ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (listContext, index) {
                                  final Map<String, dynamic> item =
                                      snapshot.data![index].data()
                                          as Map<String, dynamic>;
                                  return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 24),
                                      child: OrderCard(
                                          status: item["Status"],
                                          item: GalaxiaCartProduct.fromJson(
                                              item)));
                                });
                          })),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Expanded(
                      child: FutureBuilder<List<DocumentSnapshot>>(
                          future: fetchCompletedOrders(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Shimmer(
                                child: ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24),
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
                            if (snapshot.data!.isEmpty ||
                                snapshot.hasError ||
                                !snapshot.hasData) {
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
                                    child: Text("You don’t have any orders yet",
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
                                        "You don’t have any completed orders at this time",
                                        textAlign: TextAlign.center,
                                        style:
                                            TextStyle(fontSize: width * 0.028)),
                                  ),
                                ],
                              );
                            }

                            return ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data?.length,
                                itemBuilder: (listContext, index) {
                                  final Map<String, dynamic> item =
                                      snapshot.data![index].data()
                                          as Map<String, dynamic>;
                                  return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 24),
                                      child: OrderCard(
                                          status: item["Status"],
                                          item: GalaxiaCartProduct.fromJson(
                                              item)));
                                });
                          })),
                ],
              ),
            ]),
          ),
        ));
  }
}
