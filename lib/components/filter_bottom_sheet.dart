import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/price_range_slider.dart';
import 'package:galaxia/theme/theme.dart';

class FilterBottomSheet extends StatefulWidget {
  final List<String>? selectedCategories;
  final String? selectedSorting;
  final List<String>? selectedRatings;
  final RangeValues? priceRange;

  final Function(List<String> categories, String sorting, List<String> ratings,
      RangeValues range)? onApplied;
  const FilterBottomSheet(
      {Key? key,
      this.onApplied,
      this.priceRange,
      this.selectedCategories,
      this.selectedRatings,
      this.selectedSorting})
      : super(key: key);

  @override
  FilterBottomSheetState createState() => FilterBottomSheetState();
}

class FilterBottomSheetState extends State<FilterBottomSheet> {
  final List<String> categories = [
    "All",
    "Clothes",
    "Shoes",
    "Bags",
    "Electronics",
    "Watch",
    "Jwellery",
    "Glasses",
    "Toys"
  ];
  final List<String> sortBy = [
    "Regular",
    "Most Recent",
    "Price Ascending",
    "Price Descending"
  ];
  final List<String> ratings = ["All", "5", "4", "3", "2", "1"];
  RangeValues priceRange = const RangeValues(0, 100000);

  List<String> selectedCategories = ["All"];
  String selectedSorting = "Regular";
  List<String> selectedRatings = ["All"];

  reset() {
    setState(() {
      selectedCategories = ["All"];
      selectedRatings = ["All"];
      selectedSorting = "Regular";
      priceRange = const RangeValues(0, 100000);
    });
  }

  selectCategory(int index) {
    if (selectedCategories.contains(categories[index])) {
      setState(() {
        selectedCategories.remove(categories[index]);
      });
    } else {
      setState(() {
        selectedCategories.add(categories[index]);
      });
    }
  }

  selectSortBy(int index) {
    setState(() {
      selectedSorting = sortBy[index];
    });
  }

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      selectedCategories = widget.selectedCategories ?? ["All"];
      selectedRatings = widget.selectedRatings ?? ["All"];
      selectedSorting = widget.selectedSorting ?? "Regular";
      priceRange = widget.priceRange ?? const RangeValues(0, 100000);
    });
  }

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
              child: Text("Sort & Filter",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              width: double.infinity,
              height: 2,
              decoration: ShapeDecoration(
                  shape: const StadiumBorder(), color: grayscale[200]),
            ),
            const SizedBox(
              height: 24,
            ),
            const Text(
              "Categories",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              height: width * 0.1,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(left: index == 0 ? 0 : 24),
                        child: FilterChip(
                          onSelected: (value) {
                            selectCategory(index);
                          },
                          selectedColor: primary[100],
                          label: Text(categories[index]),
                          selected:
                              selectedCategories.contains(categories[index]),
                          showCheckmark: false,
                          backgroundColor: grayscale[100],
                          side: BorderSide(
                              color:
                                  selectedCategories.contains(categories[index])
                                      ? primary[500] ?? Colors.blue
                                      : grayscale[200] ?? Colors.black38),
                          shape: const StadiumBorder(),
                        ),
                      )),
            ),
            const SizedBox(
              height: 24,
            ),
            const Text(
              "Price Range",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 24,
            ),
            PriceRangeSlider(
              range: priceRange,
              onChange: (value) {
                setState(() {
                  priceRange = value;
                });
              },
            ),
            const Text(
              "Sort By",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              height: width * 0.1,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: sortBy.length,
                  itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(left: index == 0 ? 0 : 24),
                        child: FilterChip(
                          onSelected: (value) {
                            selectSortBy(index);
                          },
                          selectedColor: primary[100],
                          label: Text(sortBy[index]),
                          selected: selectedSorting == (sortBy[index]),
                          showCheckmark: false,
                          backgroundColor: grayscale[100],
                          side: BorderSide(
                              color: selectedSorting == (sortBy[index])
                                  ? primary[500] ?? Colors.blue
                                  : grayscale[200] ?? Colors.black38),
                          shape: const StadiumBorder(),
                        ),
                      )),
            ),
            const SizedBox(
              height: 24,
            ),
            const Text(
              "Rating",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 24,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  ratings.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(left: index == 0 ? 0 : 24),
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
            Container(
              width: double.infinity,
              height: 2,
              decoration: ShapeDecoration(
                  shape: const StadiumBorder(), color: grayscale[200]),
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: grayscale[200],
                          foregroundColor: grayscale[600]),
                      onPressed: reset,
                      child: Text(
                        "Reset",
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
                          widget.onApplied!(selectedCategories, selectedSorting,
                              selectedRatings, priceRange);
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Apply",
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
