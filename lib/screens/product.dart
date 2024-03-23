import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/providers/local_notification_service.dart';

import 'package:galaxia/screens/home/ratings_and_reviews.dart';

import 'package:galaxia/components/color_selector.dart';
import 'package:galaxia/components/counter.dart';
import 'package:galaxia/components/image_carousal.dart';
import 'package:galaxia/components/size_selector.dart';

import 'package:galaxia/store/galaxia_product.dart';

import 'package:galaxia/theme/theme.dart';
import 'package:uuid/uuid.dart';

enum CartButtonState { done, normal, validating, error }

class Product extends StatefulWidget {
  final GalaxiaProduct item;
  const Product({super.key, required this.item});
  @override
  ProductState createState() => ProductState();
}

class ProductState extends State<Product> {
  GalaxiaCartProduct? cartItem;
  CartButtonState buttonState = CartButtonState.normal;
  Uuid uuid = const Uuid();
  int quantity = 1;
  late String color;
  late String size;
  final Completer<void> _completer = Completer<void>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  addToCart() async {
    setState(() {
      buttonState = CartButtonState.validating;
    });
    try {
      await firestore.runTransaction((transaction) async {
        final ref = FirebaseFirestore.instance
            .collection('Cart')
            .doc(auth.currentUser?.uid);
        final snapshot = await transaction.get(ref);
        final findItem = await ref
            .collection("Item")
            .where("Product ID", isEqualTo: widget.item.id)
            .where("Color", isEqualTo: color)
            .where("Size", isEqualTo: size)
            .limit(1)
            .get();

        DocumentSnapshot? sameItem = findItem.docs.isNotEmpty
            ? await transaction.get(findItem.docs[0].reference)
            : null;

        if (snapshot.exists) {
          final count = snapshot.data()?['Count'] ?? 0;
          final num subTotal = snapshot.data()?['Total'];

          final newCount = count + 1;
          final num newSubTotal = (subTotal + (widget.item.price! * quantity));

          // Update the existing document

          transaction.update(ref, {
            'Count': sameItem?.exists ?? false ? newCount - 1 : newCount,
            'Total': newSubTotal,
          });
        } else {
          // Document doesn't exist, create a new one
          transaction.set(ref, {
            'Count': 1,
            'Total': (widget.item.price ?? 0 * quantity),
            'Date Created': Timestamp.now()
          });
        }
        if (sameItem?.exists ?? false) {
          transaction.update(sameItem!.reference, {
            "Quantity": sameItem.get("Quantity") + quantity,
          });
        } else {
          transaction.set(ref.collection("Item").doc(), {
            "Product ID": widget.item.id,
            "Image": widget.item.images![0],
            "Name": widget.item.name,
            "Quantity": quantity,
            "Price": widget.item.price,
            "Color": color,
            "Size": size
          });
        }
      });
      if (mounted) {
        if (!_completer.isCompleted) {
          setState(() {
            buttonState = CartButtonState.done;
          });
        }
      }
    } catch (e) {
      print(e);
      if (mounted) {
        if (!_completer.isCompleted) {
          setState(() {
            buttonState = CartButtonState.error;
          });
        }
      }
    }

    if (mounted) {
      Future.delayed(const Duration(seconds: 2), () {
        if (!_completer.isCompleted) {
          setState(() {
            buttonState = CartButtonState.normal;
          });
        }
      });
    }
    LocalNotificationService().showNotification(
        title: "Cart Updated", body: "Item successfully added to cart!");
  }

  @override
  void dispose() {
    // Cancel the delayed operation if the widget is disposed
    _completer.complete();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      cartItem = GalaxiaCartProduct(
          uid: uuid.v1(),
          id: widget.item.id,
          quantity: 1,
          name: widget.item.name,
          price: widget.item.price,
          color: widget.item.colors![0],
          image: widget.item.images![0],
          size: widget.item.sizes![0]);
      color = widget.item.colors![0];
      size = widget.item.sizes![0];
    });
  }

  updateQuantity(int value) {
    setState(() {
      quantity = value;
    });
  }

  updateSize(String value) {
    setState(() {
      size = value;
    });
  }

  Widget showCartButtonChild() {
    if (buttonState == CartButtonState.done) {
      return Icon(
        Icons.check,
        color: primary[900],
      );
    } else if (buttonState == CartButtonState.validating) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 4,
          valueColor: AlwaysStoppedAnimation(primary[900]),
          color: primary[900],
        ),
      );
    } else if (buttonState == CartButtonState.error) {
      return SvgPicture.asset(
        "assets/icons/Cross.svg",
        width: 16,
      );
    }
    return Row(
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
          "Add To Cart",
          style: TextStyle(color: primary[900]),
        )
      ],
    );
  }

  updateColor(String value) {
    setState(() {
      color = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: grayscale[400],
              height: MediaQuery.of(context).size.height * 0.4,
              child: ImageCarousal(images: widget.item.images!),
            ),
            Expanded(
                child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.item.name!,
                          style: TextStyle(
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                        ),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon:
                              SvgPicture.asset("assets/icons/Heart Filled.svg"))
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        decoration: ShapeDecoration(
                            shape: const StadiumBorder(), color: primary[500]),
                        child: Text(
                          "${widget.item.soldCount} Sold",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      SvgPicture.asset(
                        "assets/icons/Half Star.svg",
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RatingsAndReviews(
                                    id: widget.item.id!,
                                  )));
                        },
                        child: Text("4.6(${widget.item.reviewCount} Reviews)",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: grayscale[500])),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 2,
                    decoration: ShapeDecoration(
                        shape: const StadiumBorder(), color: grayscale[200]),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        widget.item.description!,
                        softWrap: true,
                        style:
                            Theme.of(context).textTheme.bodyLarge?.copyWith(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizeSelector(
                        sizes: widget.item.sizes!,
                        onChange: (value) => updateSize(value),
                      ),
                      ColorSelector(
                        colors: widget.item.colors!,
                        onChange: (value) => updateColor(value),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      Text(
                        "Quantity",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Counter(
                        iconSize: width * 0.12,
                        padding: 16,
                        onChange: (value) => updateQuantity(value),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 2,
                    decoration: ShapeDecoration(
                        shape: const StadiumBorder(), color: grayscale[200]),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            )),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.8),
                        spreadRadius: 8,
                        blurRadius: 24,
                        offset: const Offset(0, -16))
                  ],
                  color: grayscale[100],
                  border: Border(top: BorderSide(color: grayscale[200]!)),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        "\$${widget.item.price}",
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
                          onPressed: buttonState == CartButtonState.normal
                              ? addToCart
                              : null,
                          child: showCartButtonChild()))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
