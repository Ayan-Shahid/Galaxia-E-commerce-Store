import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/shimmer.dart';
import 'package:galaxia/store/review_state.dart';
import 'package:galaxia/theme/theme.dart';

class ReviewCard extends StatefulWidget {
  final ReviewItem item;
  const ReviewCard({Key? key, required this.item}) : super(key: key);

  @override
  ReviewCardState createState() => ReviewCardState();
}

class ReviewUser {
  final String? name;
  final String? photoUrl;

  const ReviewUser({this.name, this.photoUrl});
}

class ReviewCardState extends State<ReviewCard> {
  ReviewUser? reviewUser;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  like() async {
    try {
      bool? hasLiked = widget.item.likes?.contains(auth.currentUser?.uid);

      if (hasLiked == null || hasLiked == false) {
        await firestore.collection("Review").doc(widget.item.id).update({
          "Likes": FieldValue.arrayUnion([auth.currentUser?.uid])
        });
        widget.item.likes?.add(auth.currentUser?.uid);
      } else {
        await firestore.collection("Review").doc(widget.item.id).update({
          "Likes": FieldValue.arrayRemove([auth.currentUser?.uid])
        });
        widget.item.likes?.remove(auth.currentUser?.uid);
      }
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  String getTime() {
    DateTime now = DateTime.now();

// Calculate the difference between the current time and the review timestamp
    Duration difference = now.difference(widget.item.date);

// Calculate the difference in minutes, hours, or days
    int minutes = difference.inMinutes;
    int hours = difference.inHours;
    int days = difference.inDays;

    String timeAgo;

// Determine the appropriate unit of time to display
    if (days > 0) {
      timeAgo = '$days Day${days > 1 ? 's' : ''} Ago';
    } else if (hours > 0) {
      timeAgo = '$hours Hour${hours > 1 ? 's' : ''} Ago';
    } else {
      timeAgo = '$minutes Minute${minutes > 1 ? 's' : ''} Ago';
    }
    return timeAgo;
  }

  getUser() async {
    try {
      DocumentSnapshot snapshot =
          await firestore.collection("Users").doc(widget.item.userId).get();

      if (mounted) {
        setState(() {
          reviewUser = ReviewUser(
              photoUrl: snapshot.get("Avatar"), name: snapshot.get("Username"));
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: grayscale[200],
              backgroundImage: reviewUser?.photoUrl != null
                  ? NetworkImage(reviewUser?.photoUrl ?? "")
                  : null,
              radius: width * 0.04,
            ),
            const SizedBox(
              width: 24,
            ),
            Text(
              reviewUser?.name ?? "User",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: ShapeDecoration(
                  shape:
                      StadiumBorder(side: BorderSide(color: grayscale[1000]!))),
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/Star.svg",
                    width: width * 0.04,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    "${widget.item.rating?.toInt()}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ],
        ),
        const SizedBox(
          height: 24,
        ),
        Text("${widget.item.text}"),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            TextButton(
                onPressed: like,
                style: TextButton.styleFrom(foregroundColor: grayscale[1000]),
                child: Row(
                  children: [
                    SvgPicture.asset("assets/icons/Heart Filled.svg"),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      "${widget.item.likes?.length}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                )),
            const SizedBox(
              width: 24,
            ),
            Text(
              getTime(),
              style: TextStyle(color: grayscale[500], fontSize: width * 0.028),
            )
          ],
        )
      ],
    );
  }
}

class ReviewCardShimmer extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ShimmerLoading(
                isLoading: true,
                child: Container(
                  width: width * 0.1,
                  height: width * 0.1,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: grayscale[200],
                  ),
                )),
            const SizedBox(
              width: 24,
            ),
            ShimmerLoading(
                isLoading: true,
                child: Container(
                  width: width * 0.1,
                  height: width * 0.04,
                  decoration: ShapeDecoration(
                      shape: const StadiumBorder(), color: grayscale[200]),
                )),
            const Spacer(),
            ShimmerLoading(
                isLoading: true,
                child: Container(
                  width: width * 0.1,
                  height: width * 0.06,
                  decoration: ShapeDecoration(
                      shape: const StadiumBorder(), color: grayscale[200]),
                ))
          ],
        ),
        const SizedBox(
          height: 24,
        ),
        ShimmerLoading(
            isLoading: true,
            child: Container(
              width: width * 0.6,
              height: width * 0.04,
              decoration: ShapeDecoration(
                  shape: const StadiumBorder(), color: grayscale[200]),
            )),
        const SizedBox(
          height: 8,
        ),
        ShimmerLoading(
            isLoading: true,
            child: Container(
              width: width * 0.7,
              height: width * 0.04,
              decoration: ShapeDecoration(
                  shape: const StadiumBorder(), color: grayscale[200]),
            )),
        const SizedBox(
          height: 8,
        ),
        ShimmerLoading(
            isLoading: true,
            child: Container(
              width: width * 0.8,
              height: width * 0.04,
              decoration: ShapeDecoration(
                  shape: const StadiumBorder(), color: grayscale[200]),
            )),
        const SizedBox(
          height: 24,
        ),
        Row(
          children: [
            ShimmerLoading(
                isLoading: true,
                child: Container(
                  width: width * 0.1,
                  height: width * 0.06,
                  decoration: ShapeDecoration(
                      shape: const StadiumBorder(), color: grayscale[200]),
                )),
            const SizedBox(
              width: 24,
            ),
            ShimmerLoading(
                isLoading: true,
                child: Container(
                  width: width * 0.1,
                  height: width * 0.06,
                  decoration: ShapeDecoration(
                      shape: const StadiumBorder(), color: grayscale[200]),
                ))
          ],
        )
      ],
    );
  }
}
