import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/shipping_mode_card.dart';
import 'package:galaxia/screens/cart/choose_payment_method.dart';
import 'package:galaxia/theme/theme.dart';

class ChooseShippingMode extends StatefulWidget {
  final double total;
  const ChooseShippingMode({Key? key, required this.total}) : super(key: key);

  @override
  ChooseShippingModeState createState() => ChooseShippingModeState();
}

class ChooseShippingModeState extends State<ChooseShippingMode> {
  List<Map<String, dynamic>> modes = [
    {
      "icon": "Package Economy",
      "mode": "Economy",
      "price": 10,
      "time": "Dec 20-23",
    },
    {
      "icon": "Package",
      "mode": "Regular",
      "price": 15,
      "time": "Dec 20-23",
    },
    {
      "icon": "Truck",
      "mode": "Cargo",
      "price": 20,
      "time": "Dec 19-23",
    },
    {
      "icon": "Express Delivery",
      "mode": "Express",
      "price": 30,
      "time": "Dec 19-23",
    },
  ];
  int selected = 0;
  select(int index) {
    setState(() {
      selected = index;
    });
  }

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
                "Choose Shipping",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: width * 0.05),
              ),
            ),
          )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.only(bottom: 24),
                    child: ShippingModeCard(
                      onPressed: () => select(index),
                      selected: selected == index ? true : false,
                      icon: modes[index]["icon"],
                      mode: modes[index]["mode"],
                      price: modes[index]["price"],
                      time: modes[index]["time"],
                    ),
                  ),
                  itemCount: modes.length,
                )
              ],
            ),
          ),
          Container(
              padding: const EdgeInsets.only(
                  top: 24, left: 24, right: 24, bottom: 24),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: grayscale[300] ?? Colors.black26)),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32))),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChoosePaymentMethod(
                              amount: widget.total,
                            )));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Apply",
                        style: TextStyle(color: primary[900]),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      SvgPicture.asset(
                        "assets/icons/Right Arrow.svg",
                        width: 16,
                        height: 16,
                      ),
                    ],
                  ))),
        ],
      ),
    );
  }
}
