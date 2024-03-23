import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/store/galaxia_product.dart';
import 'package:galaxia/theme/theme.dart';
import 'package:galaxia/utilities/hex_to_color.dart';

class CheckOutItemCard extends StatelessWidget {
  final GalaxiaCartProduct item;
  const CheckOutItemCard({Key? key, required this.item}) : super(key: key);

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
                      ),
                    ),
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
                      width: 12,
                    ),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: hexToColor(item.color!)),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      "| Size = ${item.size}",
                      style: TextStyle(
                          color: grayscale[600], fontSize: width * 0.022),
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        "\$${item.price}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.04),
                      ),
                    )),
                    const SizedBox(
                      width: 24,
                    ),
                    Container(
                      width: width * 0.1,
                      height: width * 0.1,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: grayscale[200]),
                      child: Text(
                        "${item.quantity}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.032),
                      ),
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
