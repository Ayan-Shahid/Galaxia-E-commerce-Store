import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/item.dart';
import 'package:galaxia/components/shimmer.dart';
import 'package:galaxia/store/galaxia_product.dart';
import 'package:galaxia/theme/theme.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class Category extends StatefulWidget {
  final String category;
  const Category({Key? key, required this.category}) : super(key: key);

  @override
  CategoryState createState() => CategoryState();
}

class CategoryState extends State<Category> {
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
        query = await firestore
            .collection("Items")
            .where("Category", isEqualTo: widget.category)
            .limit(10)
            .get();
      } else {
        query = await firestore
            .collection("Items")
            .where("Category", isEqualTo: widget.category)
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

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
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
                widget.category,
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
        child: showProducts(context),
      )),
    );
  }
}
