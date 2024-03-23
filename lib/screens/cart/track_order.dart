import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/check_out_item_card.dart';
import 'package:galaxia/components/timeline_item.dart';
import 'package:galaxia/store/galaxia_product.dart';
import 'package:galaxia/theme/theme.dart';

class TrackOrder extends StatelessWidget {
  final GalaxiaCartProduct? item;
  const TrackOrder({Key? key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(width * 0.16),
          child: Container(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
            child: AppBar(
              flexibleSpace: Container(color: grayscale[100]),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    "assets/icons/Search.svg",
                  ),
                ),
              ],
              centerTitle: false,
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: SvgPicture.asset(
                    "assets/icons/Left Arrow.svg",
                    width: 32,
                    height: 32,
                  )),
              title: Text(
                "Track Order",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: width * 0.05),
              ),
            ),
          )),
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckOutItemCard(item: item!),
            const SizedBox(
              height: 24,
            ),
            Divider(
              color: grayscale[200],
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              "Order Status Details",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: width * 0.04),
            ),
            const SizedBox(
              height: 24,
            ),
            const TimelineItem(
              day: "Jan 27",
              time: "09:38",
              title: "Delivered",
              location: "Your package has been successfully delivered",
              completed: false,
            ),
            const TimelineItem(
              day: "Jan 26",
              time: "09:38",
              title: "Out for Delivery",
              location:
                  "Our delivery partner will attempt to deliver your package today",
              completed: false,
            ),
            const TimelineItem(
              day: "Jan 25",
              time: "18:30",
              title: "Shipped",
              location:
                  "Your package is on the way to our lat mile hub with tracking number 123242 from where it will be delivered to you",
              completed: false,
            ),
            const TimelineItem(
              day: "Jan 23",
              time: "23:46",
              title: "Reached our Logistics Facility",
              location:
                  "Your package has arrived at our logistics facility from where it will be sent to the last mile hub [Lahore - Kot Lakh Pat]",
              completed: true,
            ),
            const TimelineItem(
              day: "Jan 23",
              time: "17:09",
              title: "Dropped Off",
              location:
                  "Your package has been dropped off by the seller and will arrive soon at our logistics facility [Lahore - Iqbal Town]",
              completed: true,
            ),
            const TimelineItem(
              day: "Jan 23",
              time: "09:14",
              title: "Processed and Ready to Ship",
              location:
                  "Your package has been processed and will be with our delivery partner soonss",
              completed: true,
            ),
          ],
        ),
      )),
    );
  }
}
