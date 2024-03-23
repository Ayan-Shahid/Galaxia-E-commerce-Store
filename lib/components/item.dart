import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/shimmer.dart';

import 'package:galaxia/screens/product.dart';

import 'package:galaxia/store/galaxia_product.dart';

import 'package:galaxia/theme/theme.dart';

class Item extends StatefulWidget {
  final GalaxiaProduct item;
  const Item({Key? key, required this.item}) : super(key: key);

  @override
  ItemState createState() => ItemState();
}

class ItemState extends State<Item> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  addWishList() async {
    try {
      await firestore.runTransaction((transaction) async {
        DocumentReference product = await transaction
            .get(firestore.collection("Items").doc(widget.item.id))
            .then((value) => value.reference);
        transaction.set(
            firestore
                .collection("Wish List")
                .doc(auth.currentUser?.uid)
                .collection("Item")
                .doc(widget.item.id),
            {"Document": product});
      });
      if (mounted) {
        setState(() {
          isWishItem = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  removeWishList() async {
    try {
      firestore.runTransaction((transaction) async {
        transaction.delete(firestore
            .collection("Wish List")
            .doc(auth.currentUser?.uid)
            .collection("Item")
            .doc(widget.item.id));
      });
      if (mounted) {
        setState(() {
          isWishItem = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  bool isWishItem = false;
  isWishListItem() async {
    try {
      return firestore.runTransaction((transaction) async {
        final DocumentSnapshot document = await transaction.get(firestore
            .collection("Wish List")
            .doc(auth.currentUser?.uid)
            .collection("Item")
            .doc(widget.item.id));

        if (mounted) {
          setState(() {
            isWishItem = document.exists;
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isWishListItem();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (prodcutContext) => Product(
                        item: widget.item,
                      )));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                        color: grayscale[200],
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(100))),
                    child: Stack(
                      children: [
                        Positioned.fill(
                            child: Container(
                          padding: const EdgeInsets.all(16),
                          child: SvgPicture.asset(
                            "assets/icons/Gallery.svg",
                            color: grayscale[300],
                          ),
                        )),
                        Positioned.fill(
                            child: Image.network(
                          widget.item.images![0],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress != null) {
                              return Container(
                                padding: const EdgeInsets.all(16),
                                child: SvgPicture.asset(
                                  "assets/icons/Gallery.svg",
                                  color: grayscale[300],
                                ),
                              );
                            }
                            return child;
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            padding: const EdgeInsets.all(16),
                            child: SvgPicture.asset(
                              "assets/icons/Gallery.svg",
                              color: grayscale[300],
                            ),
                          ),
                        )),
                        Positioned(
                            right: width * 0.04,
                            top: width * 0.04,
                            child: IconButton(
                                style: IconButton.styleFrom(
                                    backgroundColor: grayscale[100]),
                                onPressed:
                                    isWishItem ? removeWishList : addWishList,
                                icon: SvgPicture.asset(
                                  "assets/icons/Heart Filled.svg",
                                  width: width * 0.05,
                                  color:
                                      isWishItem ? error[500] : grayscale[1000],
                                )))
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  widget.item.name!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/Half Star.svg",
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      "${widget.item.averageRating} | ",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold, color: grayscale[500]),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      decoration: ShapeDecoration(
                          shape: const StadiumBorder(), color: primary[500]),
                      child: Text(
                        "${widget.item.soldCount} Sold",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "\$${widget.item.price}",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                )
              ],
            )),
      ),
    );
  }
}

class ItemShimmer extends StatelessWidget {
  const ItemShimmer({super.key});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(100))),
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: ShimmerLoading(
                      isLoading: true,
                      child: Container(
                        color: grayscale[200],
                        width: width,
                        height: width,
                      ),
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            ShimmerLoading(
              isLoading: true,
              child: Container(
                decoration: ShapeDecoration(
                    color: grayscale[200],
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(24))),
                height: 24,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ShimmerLoading(
              isLoading: true,
              child: Container(
                decoration: ShapeDecoration(
                    color: grayscale[200],
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(24))),
                height: 24,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ShimmerLoading(
              isLoading: true,
              child: Container(
                decoration: ShapeDecoration(
                    color: grayscale[200],
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(24))),
                height: 24,
              ),
            ),
          ],
        ));
  }
}
