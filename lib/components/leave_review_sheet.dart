import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/check_out_item_card.dart';
import 'package:galaxia/store/galaxia_product.dart';

import 'package:galaxia/theme/theme.dart';

class LeaveReviewSheet extends StatefulWidget {
  final GalaxiaCartProduct item;
  const LeaveReviewSheet({Key? key, required this.item}) : super(key: key);

  @override
  LeaveReviewSheetState createState() => LeaveReviewSheetState();
}

class LeaveReviewSheetState extends State<LeaveReviewSheet> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController review = TextEditingController();

  onSubmit() async {
    try {
      firestore.collection("Review").add({
        "User ID": auth.currentUser?.uid,
        "Product ID": widget.item.id,
        "Review": review.text,
        "Rating": rating,
        "Likes": FieldValue.arrayUnion([]),
        "Date": DateTime.timestamp()
      });
    } catch (e) {
    } finally {
      Navigator.of(context).pop();
    }
  }

  double rating = 0;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return FittedBox(
      fit: BoxFit.fitHeight,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: grayscale[100],
            border: Border.fromBorderSide(
                BorderSide(color: grayscale[200] ?? Colors.black38)),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 4,
                width: width * 0.1,
                color: grayscale[200],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Center(
              child: Text("Leave a Review",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ),
            Divider(
              color: grayscale[200],
              thickness: 2,
              height: 48,
            ),
            CheckOutItemCard(item: widget.item),
            Divider(
              color: grayscale[200],
              thickness: 2,
              height: 48,
            ),
            Center(
              child: Text(
                "How was your order?",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: width * 0.042),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Center(
              child: Text(
                "Please give your rating and also your review...",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: width * 0.03),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Center(
              child: RatingBar.builder(
                itemCount: 5,
                onRatingUpdate: (value) {
                  setState(() {
                    rating = value;
                  });
                },
                unratedColor: warning[100],
                initialRating: 0,
                allowHalfRating: false,
                glow: false,
                itemPadding: EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) => SvgPicture.asset(
                  "assets/icons/Star.svg",
                  color: warning[500],
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            TextFormField(
              controller: review,
              decoration: InputDecoration(
                  hintText: "Leave a review...",
                  helperStyle: TextStyle(color: grayscale[500]),
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(right: 8, left: 8),
                    child: IconButton(
                        style: IconButton.styleFrom(shape: CircleBorder()),
                        onPressed: () {},
                        icon: SvgPicture.asset("assets/icons/Gallery.svg")),
                  )),
            ),
            Divider(
              color: grayscale[200],
              thickness: 2,
              height: 48,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: grayscale[200],
                          foregroundColor: grayscale[600]),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            color: grayscale[1000],
                            fontWeight: FontWeight.bold),
                      )),
                ),
                const SizedBox(
                  width: 24,
                ),
                Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(),
                        onPressed: () {
                          onSubmit();
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              color: primary[900], fontWeight: FontWeight.bold),
                        )))
              ],
            ),
            const SizedBox(
              height: 24,
            )
          ],
        ),
      ),
    );
  }
}
