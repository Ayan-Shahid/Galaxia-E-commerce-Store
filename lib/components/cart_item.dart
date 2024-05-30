import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/check_out_item_card.dart';
import 'package:galaxia/components/counter.dart';

import 'package:galaxia/store/galaxia_product.dart';

import 'package:galaxia/theme/theme.dart';
import 'package:galaxia/utilities/hex_to_color.dart';

class CartItem extends StatefulWidget {
  final GalaxiaCartProduct item;

  const CartItem({super.key, required this.item});

  @override
  CartItemState createState() => CartItemState();
}

class CartItemState extends State<CartItem> {
  Timer? increment_counter_deboune;

  updateQuantity(int value) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    if (increment_counter_deboune?.isActive ?? false) {
      increment_counter_deboune?.cancel();
    }
    increment_counter_deboune = Timer(Duration(seconds: 2), () async {
      final ref = firestore.collection("Cart").doc(auth.currentUser?.uid);
      final collection = ref.collection("Item");

      try {
        await firestore.runTransaction((transaction) async {
          final numTotal = await transaction.get(ref);
          final product =
              await transaction.get(collection.doc(widget.item.uid));
          num newSubTotal = numTotal.get("Total");
          final int currentQuantity = product.get("Quantity");

          if (value > currentQuantity) {
            newSubTotal += (widget.item.price! * (value - currentQuantity));
          } else {
            newSubTotal -= (widget.item.price! * (currentQuantity - value));
          }

          transaction
              .update(collection.doc(widget.item.uid), {"Quantity": value});

          transaction.update(
              firestore.collection("Cart").doc(auth.currentUser?.uid),
              {"Total": newSubTotal});
        });
      } catch (e) {
        print(e);
      }
    });
  }

  removeFromCart(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      firestore.runTransaction((transaction) async {
        transaction.delete(firestore
            .collection("Cart")
            .doc(auth.currentUser?.uid)
            .collection("Item")
            .doc(widget.item.uid));

        final DocumentReference ref =
            firestore.collection("Cart").doc(auth.currentUser?.uid);
        final DocumentSnapshot data = await ref.get();
        if (data.get("Count") == 1) {
          transaction.delete(ref);
        } else {
          int count = data.get("Count");
          dynamic total = data.get("Total");
          total = total - widget.item.price! * widget.item.quantity!;
          transaction.update(ref, {"Count": count - 1, "Total": total});
        }
      });
      popSheet(context);
    } catch (e) {
      print(e);
    }
  }

  popSheet(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(88),
              side: BorderSide(color: grayscale[200] ?? Colors.black45))),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                    color: grayscale[200],
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(56))),
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
                        child: Image.network(widget.item.image!,
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
                                )))
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 24,
          ),
          SizedBox(
            width: width * 0.46,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          "${widget.item.name}",
                          style: TextStyle(
                            fontSize: width * 0.034,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    SizedBox(
                      width: width * 0.08,
                      height: width * 0.08,
                      child: IconButton(
                          style:
                              IconButton.styleFrom(padding: EdgeInsets.all(8)),
                          onPressed: () {
                            showModalBottomSheet(
                                showDragHandle: false,
                                context: context,
                                builder: (sheetContext) {
                                  return FittedBox(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                          color: grayscale[100],
                                          border: Border.fromBorderSide(
                                              BorderSide(
                                                  color: grayscale[200] ??
                                                      Colors.black38)),
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(24),
                                              topRight: Radius.circular(24))),
                                      child: Column(
                                        children: [
                                          Text("Remove From Cart?",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 2,
                                            decoration: ShapeDecoration(
                                                shape: const StadiumBorder(),
                                                color: grayscale[200]),
                                          ),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          CheckOutItemCard(
                                            item: widget.item,
                                          ),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 2,
                                            decoration: ShapeDecoration(
                                                shape: const StadiumBorder(),
                                                color: grayscale[200]),
                                          ),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                grayscale[200],
                                                            foregroundColor:
                                                                grayscale[600]),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                          color:
                                                              grayscale[1000],
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                              ),
                                              const SizedBox(
                                                width: 24,
                                              ),
                                              Expanded(
                                                  child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(),
                                                      onPressed: () =>
                                                          removeFromCart(
                                                              context),
                                                      child: Text(
                                                        "Remove",
                                                        style: TextStyle(
                                                            color: primary[900],
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                });
                          },
                          padding: EdgeInsets.zero,
                          icon: SvgPicture.asset(
                            "assets/icons/Trash.svg",
                            width: width * 0.04,
                          )),
                    )
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text(
                      "Color",
                      style: TextStyle(
                          color: grayscale[600], fontSize: width * 0.022),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Container(
                      width: width * 0.018,
                      height: width * 0.018,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: hexToColor(widget.item.color!)),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      "| Size = ${widget.item.size}",
                      style: TextStyle(
                          color: grayscale[600], fontSize: width * 0.022),
                    )
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          "\$${widget.item.price}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.042),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Cart")
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .collection("Item")
                          .doc(widget.item.uid!)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            snapshot.hasError ||
                            snapshot.hasData == false) {
                          return Text("Hello");
                        }
                        int quantity = snapshot.data!.get("Quantity");

                        return Counter(
                          value: quantity,
                          countStyle: TextStyle(fontSize: width * 0.032),
                          iconSize: width * 0.1,
                          padding: 12,
                          onChange: (value) => updateQuantity(value),
                        );
                      },
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
