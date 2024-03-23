import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/filter_bottom_sheet.dart';
import 'package:galaxia/components/item.dart';
import 'package:galaxia/components/shimmer.dart';
import 'package:galaxia/store/galaxia_product.dart';

import 'package:galaxia/theme/theme.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SearchMetadata {
  final int nbHits;

  const SearchMetadata(this.nbHits);

  factory SearchMetadata.fromResponse(SearchResponse response) =>
      SearchMetadata(response.nbHits);
}

class HitsPage {
  const HitsPage(this.items, this.pageKey, this.nextPageKey);

  final List<GalaxiaProduct> items;
  final int pageKey;
  final int? nextPageKey;

  factory HitsPage.fromResponse(SearchResponse response) {
    // response.hits.first.values.forEach((element) {
    //   print(element);
    // });
    final items = response.hits
        .map((element) => GalaxiaProduct.fromAlgoliaJson(element))
        .toList();

    final isLastPage = response.page >= response.nbPages;
    final nextPageKey = isLastPage ? null : response.page + 1;
    return HitsPage(items, response.page, nextPageKey);
  }
}

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  final TextEditingController controller = TextEditingController();
  final FilterState filterState = FilterState();
  late final FacetList _facetList = FacetList(
    searcher: _productsSearcher,
    filterState: filterState,
    attribute: 'Category',
  );

  Stream<SearchMetadata> get _searchMetadata =>
      _productsSearcher.responses.map(SearchMetadata.fromResponse);
  final PagingController<int, GalaxiaProduct> _pagingController =
      PagingController(firstPageKey: 0);

  Stream<HitsPage> get _searchPage =>
      _productsSearcher.responses.map(HitsPage.fromResponse);

  Widget _hits(BuildContext context) => PagedGridView<int, GalaxiaProduct>(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 24,
            crossAxisCount: 2,
            childAspectRatio: MediaQuery.of(context).size.width * 0.00132,
            crossAxisSpacing: 24),
        pagingController: _pagingController,
        showNoMoreItemsIndicatorAsGridChild: false,
        showNewPageProgressIndicatorAsGridChild: false,
        builderDelegate: PagedChildBuilderDelegate<GalaxiaProduct>(
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
                          "We encountered a problem while searching for your data!",
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
                          "We encountered a problem while searching for your data!",
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
                          "We are not able to find the item you are searching for!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.028)),
                    ),
                  ],
                ),
            itemBuilder: (_, item, __) => Item(
                  item: item,
                )),
      );

  final HitsSearcher _productsSearcher = HitsSearcher(
      applicationID: dotenv.env["ALGOLIA_APP_ID"] as String,
      apiKey: dotenv.env["ALGOLIA_SEARCH_KEY"] as String,
      indexName: "Galaxia Regular");

  // final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<String> categoryFilters = ["All"];
  String? sortByFilter;
  List<String> ratingFilter = ["All"];
  RangeValues? priceFilter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller.addListener(() => _productsSearcher.applyState(
          (state) => state.copyWith(
            query: controller.text,
            page: 0,
          ),
        ));
    _searchPage.listen((page) {
      if (page.pageKey == 0) {
        _pagingController.refresh();
      }
      _pagingController.appendPage(page.items, page.nextPageKey);
    }).onError((error) {
      print(error);
      _pagingController.error = error;
    });

    _pagingController.addPageRequestListener(
        (pageKey) => _productsSearcher.applyState((state) => state.copyWith(
              page: pageKey,
            )));
    _productsSearcher.connectFilterState(filterState);
    filterState.filters.listen((_) => _pagingController.refresh());
  }

  @override
  void dispose() {
    // TODO: implement dispose

    controller.dispose();
    _productsSearcher.dispose();

    _pagingController.dispose();
    filterState.dispose();
    _facetList.dispose();
    super.dispose();
  }

  onFiltersApplied(List<String> categories, String? sorting,
      List<String> ratings, RangeValues range) async {
    filterState.clear([
      const FilterGroupID("Category", FilterOperator.or),
      const FilterGroupID("Price"),
      const FilterGroupID("Rating", FilterOperator.or),
    ]);

    setState(() {
      categoryFilters = categories;
      sortByFilter = sorting;
      ratingFilter = ratings;
      priceFilter = range;
    });

    if (categoryFilters.contains("All")) {
      filterState.add(const FilterGroupID("Category", FilterOperator.or), []);
    } else {
      filterState.add(const FilterGroupID("Category", FilterOperator.or),
          categoryFilters.map((e) => Filter.facet("Category", e)));
    }

    if (priceFilter != null) {
      filterState.add(const FilterGroupID("Price"), [
        Filter.range("Price",
            lowerBound: priceFilter!.start, upperBound: priceFilter!.end)
      ]);
    }

    _productsSearcher.applyState(
        (state) => state.copyWith(indexName: "Galaxia $sortByFilter"));

    if (!ratings.contains("All")) {
      filterState.add(
          const FilterGroupID("Rating", FilterOperator.or),
          ratings.map((e) => Filter.comparison(
              "Rating", NumericOperator.lessOrEquals, int.parse(e))));
    } else {
      filterState.clear([const FilterGroupID("Rating")]);
    }
  }

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
                    "assets/icons/Dots Horizontal.svg",
                  ),
                ),
              ],
              centerTitle: false,
              leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: SvgPicture.asset(
                    "assets/icons/Left Arrow.svg",
                    width: width * 0.08,
                  )),
              title: Text(
                "Search",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: width * 0.05),
              ),
            ),
          )),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: controller,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.only(top: 20, bottom: 20, left: 72),
                  labelText: "Search",
                  labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold, color: grayscale[500]),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    child: SvgPicture.asset("assets/icons/Search.svg",
                        width: 20, color: grayscale[500]),
                  ),
                  suffixIcon: IconButton(
                    style: IconButton.styleFrom(shape: const CircleBorder()),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => FilterBottomSheet(
                          selectedCategories: categoryFilters,
                          selectedRatings: ratingFilter,
                          selectedSorting: sortByFilter,
                          priceRange: priceFilter,
                          onApplied: (categories, sorting, ratings, range) =>
                              onFiltersApplied(
                                  categories, sorting, ratings, range),
                        ),
                      );
                    },
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    icon: SvgPicture.asset(
                      "assets/icons/Filter.svg",
                      color: grayscale[500],
                      width: 20,
                    ),
                  )),
            ),
            const SizedBox(
              height: 24,
            ),
            StreamBuilder<SearchMetadata>(
              stream: _searchMetadata,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Results for \n\"${controller.text}\"",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.04),
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    Text("${snapshot.data?.nbHits} Found",
                        style: TextStyle(
                            color: grayscale[600], fontSize: width * 0.032))
                  ],
                );
              },
            ),
            const SizedBox(
              height: 24,
            ),
            Expanded(
              child: _hits(context),
            )
          ],
        ),
      )),
    );
  }
}
