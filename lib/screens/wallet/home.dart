import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/e_wallet_card.dart';
import 'package:galaxia/components/transaction_card.dart';
import 'package:galaxia/theme/theme.dart';

class Home extends StatelessWidget {
  const Home({super.key});
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
                    "assets/icons/Search.svg",
                  ),
                ),
              ],
              centerTitle: false,
              leading: SvgPicture.asset("assets/icons/Logo.svg"),
              title: const Text(
                "My E-Wallet",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            const EWalletCard(),
            const SizedBox(
              height: 24,
            ),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("E-Wallet")
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .collection("Transaction")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        "assets/illustrations/400 Error.svg",
                        width: width * 0.4,
                      ),
                      SizedBox(
                        width: width * 0.6,
                        child: Text("Error!",
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
                            "We encountered an error while fetching data!",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: width * 0.028)),
                      ),
                    ],
                  );
                }
                if (!snapshot.hasData ||
                    snapshot.data?.docs == null ||
                    snapshot.data!.docs.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        "assets/illustrations/No Data.svg",
                        width: width * 0.4,
                      ),
                      SizedBox(
                        width: width * 0.6,
                        child: Text("No Data!",
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
                        child: Text("You don't have any transactions!",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: width * 0.028)),
                      ),
                    ],
                  );
                }
                return ListView.builder(
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data = snapshot.data?.docs[index]
                        .data() as Map<String, dynamic>;

                    Timestamp date = data["Date"];
                    return TransactionCard(
                      type: data["Type"],
                      image: data["Image"],
                      amount: data["Price"],
                      name: data["Title"],
                      date: date.toDate(),
                    );
                  },
                  itemCount: snapshot.data?.docs.length,
                  shrinkWrap: true,
                );
              },
            ))
          ],
        ),
      )),
    );
  }
}
