import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/item.dart';
import 'package:galaxia/components/shimmer.dart';

import 'package:galaxia/store/galaxia_product.dart';

import 'package:galaxia/theme/theme.dart';

class WishList extends StatefulWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  WishListState createState() => WishListState();
}

class WishListState extends State<WishList> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool loading = false;
  final List<String> categories = [
    "All",
    "Clothes",
    "Shoes",
    "Bags",
    "Electronics",
    "Glasses",
    "Toys",
    "Jwellery"
  ];
  List<String> selectedCategories = ["All"];

  selectCategory(int index) {
    if (selectedCategories.contains(categories[index])) {
      selectedCategories.remove(categories[index]);
    } else {
      selectedCategories.add(categories[index]);
    }

    if (selectedCategories.contains("All") == false) {
      setState(() {
        filtered = data
            .where((element) =>
                selectedCategories.contains(element.get("Category")))
            .toList();
      });
    } else {
      setState(() {
        filtered = data;
      });
    }
  }

  List<DocumentSnapshot> data = [];
  List<DocumentSnapshot> filtered = [];

  Future<List<DocumentSnapshot>> fetchData() async {
    setState(() {
      loading = true;
    });
    try {
      QuerySnapshot list = await firestore
          .collection("Wish List")
          .doc(auth.currentUser?.uid)
          .collection("Item")
          .get();
      List<DocumentSnapshot> items = [];
      for (DocumentSnapshot element in list.docs) {
        DocumentSnapshot product =
            await firestore.collection("Items").doc(element.id).get();
        items.add(product);
      }
      if (mounted) {
        setState(() {
          loading = false;
          filtered = items;
          data = items;
        });
      }
      return items;
    } catch (e) {
      print(e);
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
      return [];
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
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
                "My Wishlist",
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
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  categories.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                        right: index == categories.length - 1 ? 0 : 24),
                    child: FilterChip(
                      onSelected: (value) {
                        selectCategory(index);
                      },
                      selectedColor: primary[100],
                      label: Text(categories[index]),
                      selected: selectedCategories.contains(categories[index]),
                      showCheckmark: false,
                      backgroundColor: grayscale[100],
                      side: BorderSide(
                          color: selectedCategories.contains(categories[index])
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
                child: filtered.isEmpty && loading == false
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            "assets/illustrations/No Data.svg",
                            width: width * 0.8,
                          ),
                          SizedBox(
                            width: width * 0.6,
                            child: Text("Wish List is Empty!",
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
                                "You don't have any items in your wish list!",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: width * 0.028)),
                          ),
                        ],
                      )
                    : loading == true
                        ? Shimmer(
                            child: GridView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisSpacing: 24,
                                        crossAxisCount: 2,
                                        childAspectRatio:
                                            MediaQuery.of(context).size.width *
                                                0.00132,
                                        crossAxisSpacing: 24),
                                itemCount: 10,
                                itemBuilder: (productsContext, index) {
                                  return const ItemShimmer();
                                }))
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.56,
                                    crossAxisSpacing: 24),
                            itemCount: filtered.length,
                            itemBuilder: (productsContext, index) {
                              Map<String, dynamic> data = filtered[index].data()
                                  as Map<String, dynamic>;
                              String rating =
                                  filtered[index].get("Average Rating");
                              data.addEntries([
                                MapEntry("objectID", filtered[index].id),
                                MapEntry("Rating", double.parse(rating)),
                              ]);
                              return Item(item: GalaxiaProduct.fromJson(data));
                            })),
          ],
        ),
      )),
    );
  }
}
