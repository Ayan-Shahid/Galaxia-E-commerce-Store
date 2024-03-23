import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/store/address_book_state.dart';
import 'package:galaxia/theme/theme.dart';

class AddressCard extends StatelessWidget {
  final AddressBookItem address;
  const AddressCard({Key? key, required this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(20),
      width: width,
      decoration: ShapeDecoration(
          shape: ContinuousRectangleBorder(
              side: BorderSide(color: grayscale[400]!),
              borderRadius: BorderRadius.circular(72)),
          color: grayscale[200]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: width * 0.16,
                height: width * 0.16,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: grayscale[300]),
                child: Container(
                  width: width * 0.1,
                  height: width * 0.1,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: grayscale[1000]),
                  child: SvgPicture.asset(
                    "assets/icons/Location.svg",
                    color: grayscale[100],
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              const SizedBox(
                width: 24,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "${address.name}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.04),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Visibility(
                          visible: address.isDefault,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: ShapeDecoration(
                                shape: StadiumBorder(), color: primary[500]),
                            child: Text(
                              "Default",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: width * 0.02),
                            ),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: width * 0.4,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        "${address.postalCode} ${address.line1}",
                        style: TextStyle(
                            color: grayscale[500], fontSize: width * 0.03),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          IconButton(
              onPressed: () {}, icon: SvgPicture.asset("assets/icons/Edit.svg"))
        ],
      ),
    );
  }
}
