import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/avatar.dart';

import 'package:galaxia/components/item.dart';
import 'package:galaxia/components/shimmer.dart';
import 'package:galaxia/screens/home/category.dart';
import 'package:galaxia/screens/home/search.dart';
import 'package:galaxia/screens/wishlist.dart';

import 'package:galaxia/store/app_state.dart';
import 'package:galaxia/store/galaxia_product.dart';

import 'package:galaxia/theme/theme.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final PagingController<DocumentSnapshot?, DocumentSnapshot>
      _pagingController = PagingController(firstPageKey: null);
  Widget showProducts(BuildContext context) =>
      PagedGridView<DocumentSnapshot?, DocumentSnapshot>(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 24,
            crossAxisCount: 2,
            childAspectRatio: MediaQuery.of(context).size.width * 0.00132,
            crossAxisSpacing: 24),
        pagingController: _pagingController,
        showNoMoreItemsIndicatorAsGridChild: false,
        showNewPageProgressIndicatorAsGridChild: false,
        showNewPageErrorIndicatorAsGridChild: false,
        builderDelegate: PagedChildBuilderDelegate<DocumentSnapshot>(
            newPageProgressIndicatorBuilder: (context) => SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Shimmer(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 24,
                        crossAxisCount: 2,
                        childAspectRatio:
                            MediaQuery.of(context).size.width * 0.00132,
                        crossAxisSpacing: 24),
                    shrinkWrap: true,
                    itemCount: 4,
                    itemBuilder: (context, index) => const ItemShimmer(),
                  ),
                )),
            firstPageProgressIndicatorBuilder: (context) => SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Shimmer(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 24,
                        crossAxisCount: 2,
                        childAspectRatio:
                            MediaQuery.of(context).size.width * 0.00132,
                        crossAxisSpacing: 24),
                    shrinkWrap: true,
                    itemCount: 4,
                    itemBuilder: (context, index) => const ItemShimmer(),
                  ),
                )),
            animateTransitions: true,
            newPageErrorIndicatorBuilder: (_) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/illustrations/400 Error.svg",
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text("An Error Occurred!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05)),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                          "We encountered a problem while fetching your data!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.028)),
                    ),
                  ],
                ),
            firstPageErrorIndicatorBuilder: (_) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/illustrations/400 Error.svg",
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text("An Error Occurred!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05)),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                          "We encountered a problem while fetching for your data!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.028)),
                    ),
                  ],
                ),
            noItemsFoundIndicatorBuilder: (_) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/illustrations/No Data.svg",
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text("No Items Found!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05)),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                          "We are not able to find any items in our store!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.028)),
                    ),
                  ],
                ),
            itemBuilder: (_, item, __) {
              List<String>? colors = [];
              item.get("Colors").forEach((element) {
                colors.add(element);
              });
              List<String>? images = [];
              item.get("Images").forEach((element) {
                images.add(element);
              });
              List<String>? sizes = [];
              item.get("Sizes").forEach((element) {
                sizes.add(element);
              });
              dynamic price = item.get("Price");

              return Item(
                item: GalaxiaProduct(
                    id: item.id,
                    name: item.get("Name"),
                    price: price is double ? price : price.toDouble(),
                    description: item.get("Description"),
                    category: item.get("Category"),
                    colors: colors,
                    sizes: sizes,
                    images: images,
                    reviewCount: item.get("Review Count"),
                    soldCount: item.get("Sold Count"),
                    averageRating: double.parse(item.get("Average Rating"))),
              );
            }),
      );

  fetchData(DocumentSnapshot? pageKey) async {
    try {
      QuerySnapshot query;

      if (pageKey == null) {
        query = await firestore.collection("Items").limit(10).get();
      } else {
        query = await firestore
            .collection("Items")
            .startAfterDocument(pageKey)
            .limit(10)
            .get();
      }

      final isLastPage = query.docs.length < 10;

      if (isLastPage) {
        _pagingController.appendLastPage(query.docs);
      } else {
        final nextPageKey =
            query.docs.last; // Assuming last document as page key
        _pagingController.appendPage(query.docs, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      fetchData(pageKey); // Call fetchData with the page key
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pagingController.dispose();
    super.dispose();
  }

  final List<Map<String, String>> categories = [
    {"icon": "Shirt", "name": "Clothes"},
    {"icon": "Shoes", "name": "Shoes"},
    {"icon": "Bag", "name": "Bags"},
    {"icon": "Computer", "name": "Electronics"},
    {"icon": "Watch", "name": "Watch"},
    {"icon": "Diamond", "name": "Jwellery"},
    {"icon": "Glasses", "name": "Glasses"},
    {"icon": "Toy", "name": "Toys"}
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Container(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
            child: AppBar(
              flexibleSpace: Container(
                color: grayscale[100],
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    "assets/icons/Bell.svg",
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const WishList()));
                    },
                    icon: SvgPicture.asset("assets/icons/Heart Filled.svg"))
              ],
              centerTitle: false,
              leading: Avatar(
                size: 40,
                url: auth.currentUser?.photoURL,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Good Morning 👋",
                    style: TextStyle(
                        color: grayscale[500], fontSize: width * 0.038),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    '${auth.currentUser?.displayName}',
                    style: TextStyle(
                        fontSize: width * 0.05,
                        color: grayscale[1000],
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          )),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: StoreBuilder<AppState>(
              builder: (galaxiaStoreContext, galaxiastore) {
                return Column(
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    TextField(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Search()));
                      },
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              top: 20, bottom: 20, left: 72),
                          labelText: "Search",
                          labelStyle: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: grayscale[500]),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 24, right: 24),
                            child: SvgPicture.asset("assets/icons/Search.svg",
                                width: 20, color: grayscale[500]),
                          ),
                          suffixIcon: IconButton(
                            style: IconButton.styleFrom(
                                shape: const CircleBorder()),
                            onPressed: () {},
                            padding: const EdgeInsets.only(left: 24, right: 24),
                            icon: SvgPicture.asset(
                              "assets/icons/Filter.svg",
                              color: grayscale[500],
                              width: 20,
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Special Offers",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              foregroundColor: grayscale[500],
                            ),
                            child: Text(
                              "See All",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: grayscale[500]),
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: width * 0.0024,
                          crossAxisCount: 4,
                          mainAxisSpacing: 12),
                      itemCount: 8,
                      itemBuilder: (BuildContext gridContext, int index) {
                        return Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Category(
                                        category: categories[index]["name"]!)));
                              },
                              padding: const EdgeInsets.all(12),
                              icon: SvgPicture.asset(
                                  "assets/glass icons/${categories[index]["icon"]}.svg"),
                              style: IconButton.styleFrom(
                                  shape: const CircleBorder(),
                                  backgroundColor: grayscale[200]),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              "${categories[index]["name"]}",
                              style: Theme.of(context).textTheme.labelSmall,
                            )
                          ],
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Most Popular",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              foregroundColor: grayscale[500],
                            ),
                            child: Text(
                              "See All",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: grayscale[500]),
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FilterChip(
                          onSelected: (value) {},
                          selectedColor: primary[100],
                          label: const Text("All"),
                          selected: true,
                          showCheckmark: false,
                          backgroundColor: grayscale[100],
                          side: BorderSide(color: primary[500] ?? Colors.blue),
                          shape: const StadiumBorder(),
                        ),
                        FilterChip(
                          onSelected: (value) {},
                          selectedColor: primary[100],
                          label: const Text("Clothes"),
                          selected: false,
                          showCheckmark: false,
                          backgroundColor: grayscale[100],
                          side:
                              BorderSide(color: grayscale[200] ?? Colors.blue),
                          shape: const StadiumBorder(),
                        ),
                        FilterChip(
                          onSelected: (value) {},
                          selectedColor: primary[100],
                          label: const Text("Shoes"),
                          selected: false,
                          showCheckmark: false,
                          backgroundColor: grayscale[100],
                          side:
                              BorderSide(color: grayscale[200] ?? Colors.blue),
                          shape: const StadiumBorder(),
                        ),
                        FilterChip(
                          onSelected: (value) {},
                          selectedColor: primary[100],
                          label: const Text("Bags"),
                          selected: false,
                          showCheckmark: false,
                          backgroundColor: grayscale[100],
                          side:
                              BorderSide(color: grayscale[200] ?? Colors.blue),
                          shape: const StadiumBorder(),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    SizedBox(
                      height: width * 1.2,
                      child: showProducts(context),
                    )
                  ],
                );
              },
            )),
      ),
    );
  }
}
