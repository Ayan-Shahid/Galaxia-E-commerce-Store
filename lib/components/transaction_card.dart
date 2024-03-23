import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/theme/theme.dart';

class TransactionCard extends StatelessWidget {
  final String type;
  final String? image;
  final num amount;
  final String name;
  final DateTime date;

  const TransactionCard(
      {Key? key,
      required this.type,
      required this.image,
      required this.amount,
      required this.name,
      required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          type == "Order"
              ? Container(
                  width: width * 0.12,
                  height: width * 0.12,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: grayscale[200]),
                  child: image != null
                      ? Image.network(
                          image!,
                          fit: BoxFit.cover,
                        )
                      : null,
                )
              : Container(
                  width: width * 0.12,
                  height: width * 0.12,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: primary[200]),
                  child: Container(
                    width: width * 0.08,
                    height: width * 0.08,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: primary[500]),
                    child: SvgPicture.asset("assets/icons/Wallet Filled.svg"),
                  ),
                ),
          const SizedBox(
            width: 24,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: width * 0.4,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: width * 0.03),
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "Dec 15, 2024 | 10:00 AM",
                style:
                    TextStyle(fontSize: width * 0.024, color: grayscale[600]),
              )
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "\$${amount.toInt()}",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: width * 0.03),
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text(
                    type,
                    style: TextStyle(
                        fontSize: width * 0.024, color: grayscale[600]),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Container(
                    width: width * 0.032,
                    height: width * 0.032,
                    padding: EdgeInsets.all(2.4),
                    decoration: BoxDecoration(
                        color: type == "Order" ? error[500] : primary[500],
                        shape: BoxShape.circle),
                    child: SvgPicture.asset(
                      "assets/icons/${type == "Order" ? "Up" : "Down"} Arrow.svg",
                      fit: BoxFit.scaleDown,
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
