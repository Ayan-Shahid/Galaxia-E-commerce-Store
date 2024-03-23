import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/leave_review_sheet.dart';
import 'package:galaxia/components/shimmer.dart';
import 'package:galaxia/screens/cart/track_order.dart';
import 'package:galaxia/store/galaxia_product.dart';
import 'package:galaxia/theme/theme.dart';
import 'package:galaxia/utilities/hex_to_color.dart';

class OrderCard extends StatelessWidget {
  final GalaxiaCartProduct item;
  final String status;
  const OrderCard({Key? key, required this.item, required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: MediaQuery.of(context).size.width,
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
                          child: Image.network(item.image!,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
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
                  )),
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
                  children: [
                    Expanded(
                        child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        "${item.name}",
                        style: TextStyle(
                            fontSize: width * 0.034,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                      ),
                    )),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                          color: hexToColor(item.color!)),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      "| Size = ${item.size}",
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: ShapeDecoration(
                                shape: const StadiumBorder(),
                                color: status == "Completed"
                                    ? success[400]
                                    : primary[500]),
                            child: Text(
                              status,
                              style: TextStyle(
                                  fontSize: width * 0.02,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    "\$${item.price}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: width * 0.032),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (status == "On Going") {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TrackOrder(
                                      item: item,
                                    )));
                          } else {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => LeaveReviewSheet(
                                item: item,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            backgroundColor: grayscale[200],
                            foregroundColor: grayscale[1000]),
                        child: Text(
                          status == "On Going" ? "Track Order" : "Leave Review",
                          style: TextStyle(fontSize: width * 0.026),
                        ))
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

class OrderCardShimmer extends StatelessWidget {
  const OrderCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(88),
              side: BorderSide(color: grayscale[200] ?? Colors.black45))),
      child: Row(
        children: [
          Expanded(
              child: AspectRatio(
                  aspectRatio: 1.0,
                  child: ShimmerLoading(
                    isLoading: true,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                          color: grayscale[200],
                          shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(56))),
                    ),
                  ))),
          const SizedBox(
            width: 24,
          ),
          SizedBox(
              width: width * 0.46,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLoading(
                        isLoading: true,
                        child: Container(
                          height: width * 0.06,
                          decoration: ShapeDecoration(
                              shape: const StadiumBorder(),
                              color: grayscale[200]),
                          width: width * 0.4,
                        )),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ShimmerLoading(
                            isLoading: true,
                            child: Container(
                              decoration: ShapeDecoration(
                                  shape: const StadiumBorder(),
                                  color: grayscale[200]),
                              height: width * 0.018,
                              width: width * 0.08,
                            )),
                        const SizedBox(
                          width: 6,
                        ),
                        ShimmerLoading(
                          isLoading: true,
                          child: Container(
                            width: width * 0.018,
                            height: width * 0.018,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: grayscale[200]),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        ShimmerLoading(
                            isLoading: true,
                            child: Container(
                              decoration: ShapeDecoration(
                                  shape: const StadiumBorder(),
                                  color: grayscale[200]),
                              height: width * 0.018,
                              width: width * 0.06,
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerLoading(
                                isLoading: true,
                                child: Container(
                                  decoration: ShapeDecoration(
                                      shape: const StadiumBorder(),
                                      color: grayscale[200]),
                                  height: width * 0.04,
                                  width: width * 0.1,
                                )),
                            const SizedBox(
                              height: 8,
                            ),
                            ShimmerLoading(
                                isLoading: true,
                                child: Container(
                                  decoration: ShapeDecoration(
                                      shape: const StadiumBorder(),
                                      color: grayscale[200]),
                                  height: width * 0.06,
                                  width: width * 0.2,
                                )),
                          ],
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        ShimmerLoading(
                            isLoading: true,
                            child: Container(
                              decoration: ShapeDecoration(
                                  shape: const StadiumBorder(),
                                  color: grayscale[200]),
                              height: width * 0.1,
                              width: width * 0.2,
                            )),
                      ],
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
