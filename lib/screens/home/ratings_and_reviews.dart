import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/review_card.dart';
import 'package:galaxia/components/shimmer.dart';

import 'package:galaxia/store/review_state.dart';
import 'package:galaxia/theme/theme.dart';

class RatingsAndReviews extends StatefulWidget {
  final String id;
  const RatingsAndReviews({Key? key, required this.id}) : super(key: key);

  @override
  RatingsAndReviewsState createState() => RatingsAndReviewsState();
}

class RatingsAndReviewsState extends State<RatingsAndReviews> {
  final List<String> ratings = ["All", "5", "4", "3", "2", "1"];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<String> selectedRatings = ["All"];
  int reviews = 0;

  selectRating(int index) {
    if (selectedRatings.contains(ratings[index])) {
      setState(() {
        selectedRatings.remove(ratings[index]);
      });
    } else {
      setState(() {
        selectedRatings.add(ratings[index]);
      });
    }
  }

  getLength() async {
    try {
      final data = await firestore
          .collection("Review")
          .where("Product ID", isEqualTo: widget.id)
          .get();
      setState(() {
        reviews = data.docs.length;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLength();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: AppBar(
              flexibleSpace: Container(
                color: grayscale[100],
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    "assets/icons/Search.svg",
                  ),
                ),
              ],
              centerTitle: false,
              title: Text(
                "4.8($reviews Reviews)",
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
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  ratings.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                        right: index == ratings.length - 1 ? 0 : 24),
                    child: FilterChip(
                      onSelected: (value) {
                        selectRating(index);
                      },
                      selectedColor: primary[100],
                      label: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/Star.svg",
                            width: width * 0.04,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(ratings[index])
                        ],
                      ),
                      selected: selectedRatings.contains(ratings[index]),
                      showCheckmark: false,
                      backgroundColor: grayscale[100],
                      side: BorderSide(
                          color: selectedRatings.contains(ratings[index])
                              ? primary[500]!
                              : grayscale[200]!),
                      shape: const StadiumBorder(),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection("Review")
                    .where("Product ID", isEqualTo: widget.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer(
                      child: ListView.builder(
                        itemCount: 12,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(bottom: index == 7 ? 0 : 24),
                          child: ReviewCardShimmer(),
                        ),
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          "assets/illustrations/No Data.svg",
                          width: width,
                        ),
                        SizedBox(
                          width: width * 0.6,
                          child: Text("There are no reviews!",
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
                          child: Text("This item does not have any reviews!",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: width * 0.028)),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/illustrations/400 Error.svg",
                          width: width,
                        ),
                        SizedBox(
                          width: width * 0.6,
                          child: Text("Error Fetching Reviews!",
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
                              "We encountered an error while fetching reviews!",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: width * 0.028)),
                        ),
                      ],
                    );
                  }
                  List<DocumentSnapshot> filtered = snapshot.data!.docs;
                  if (selectedRatings.contains("All") == false) {
                    filtered = snapshot.data!.docs.where((element) {
                      num rating = element.get("Rating");

                      return selectedRatings
                          .contains(rating.toInt().toString());
                    }).toList();
                  } else {
                    filtered = snapshot.data!.docs;
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data =
                          filtered[index].data() as Map<String, dynamic>;
                      data.addEntries([MapEntry("ID", filtered[index].id)]);
                      return Padding(
                        padding: EdgeInsets.only(bottom: index == 7 ? 0 : 24),
                        child: ReviewCard(
                          item: ReviewItem.fromJson(data),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
