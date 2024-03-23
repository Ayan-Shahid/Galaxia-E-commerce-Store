import 'dart:io';

import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/invoice.dart';

import 'package:galaxia/store/galaxia_product.dart';

import 'package:galaxia/theme/theme.dart';
import 'package:galaxia/utilities/build_barcode.dart';
import 'package:galaxia/utilities/hex_to_color.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:uuid/uuid.dart';

class EReciept extends StatefulWidget {
  final List<GalaxiaCartProduct> item;
  final num amount;
  final String paymentMethod;
  final DateTime date;
  final String transactionId;
  const EReciept(
      {Key? key,
      required this.item,
      required this.amount,
      required this.paymentMethod,
      required this.date,
      required this.transactionId})
      : super(key: key);

  @override
  ERecieptState createState() => ERecieptState();
}

class ERecieptState extends State<EReciept> {
  final pdf = Invoice();
  printPdf() async {
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  sharePdf() async {
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'invoice.pdf');
  }

  downloadPdf() async {
    try {
      // LocalNotificationService()
      //     .showNotification(title: "Sample Title", body: "It Works");
      final path = await getApplicationDocumentsDirectory();
      final file = File("${path.path}/invoice.pdf");
      await file
          .writeAsBytes(await pdf.save())
          .then((value) => OpenFile.open(value.path));
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    makePdf();
  }

  makePdf() async {
    pdf.build(widget.item);
  }

  String uid = const Uuid().v1();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(width * 0.16),
          child: Container(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
            child: AppBar(
              flexibleSpace: Container(color: grayscale[100]),
              actions: [
                PopupMenuButton(
                  color: grayscale[200],
                  elevation: 0.0,
                  shape: ContinuousRectangleBorder(
                      side: BorderSide(color: grayscale[400]!),
                      borderRadius: BorderRadius.circular(72)),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                        onTap: () {
                          sharePdf();
                        },
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/icons/Send.svg"),
                            const SizedBox(
                              width: 24,
                            ),
                            Text(
                              "Share E-Receipt",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: grayscale[1000]),
                            )
                          ],
                        )),
                    PopupMenuItem(
                        onTap: () {
                          downloadPdf();
                        },
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                                "assets/icons/Download Document.svg"),
                            const SizedBox(
                              width: 24,
                            ),
                            Text(
                              "Download E-Receipt",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: grayscale[1000]),
                            )
                          ],
                        )),
                    PopupMenuItem(
                        onTap: () {
                          printPdf();
                        },
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/icons/Print.svg"),
                            const SizedBox(
                              width: 24,
                            ),
                            Text(
                              "Print",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: grayscale[1000]),
                            )
                          ],
                        )),
                  ],
                )
              ],
              centerTitle: false,
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .popUntil((route) => route.settings.name == '/');
                  },
                  icon: SvgPicture.asset(
                    "assets/icons/Left Arrow.svg",
                    width: 32,
                    height: 32,
                  )),
              title: Text(
                "E-Receipt",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: width * 0.05),
              ),
            ),
          )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          Center(
              child: buildBarcode(
            Barcode.codabar(),
            "124132131212",
            filename: "Barcode",
            width: width * 0.76,
            height: width * 0.3,
            fontHeight: width * 0.032,
          )),
          const SizedBox(
            height: 24,
          ),
          Container(
              padding: const EdgeInsets.all(24),
              width: width,
              decoration: ShapeDecoration(
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(80)),
                  color: grayscale[200]),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.item.length,
                itemBuilder: (context, index) => Container(
                  padding: EdgeInsets.only(top: index == 0 ? 0 : 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: width * 0.14,
                        height: width * 0.14,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(widget.item[index].image!)),
                            shape: BoxShape.circle,
                            color: grayscale[300]),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.item[index].name!,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: width * 0.032)),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Quantity = ${widget.item[index].quantity}",
                              style: TextStyle(
                                  color: grayscale[500],
                                  fontSize: width * 0.028),
                            )
                          ],
                        ),
                      )),
                      const SizedBox(
                        width: 24,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Color",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: width * 0.032),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Container(
                                width: width * 0.04,
                                height: width * 0.04,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        hexToColor(widget.item[index].color!)),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            "Size = ${widget.item[index].size}",
                            style: TextStyle(
                                color: grayscale[500], fontSize: width * 0.028),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )),
          const SizedBox(
            height: 24,
          ),
          Container(
              padding: const EdgeInsets.all(24),
              width: width,
              decoration: ShapeDecoration(
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(80)),
                  color: grayscale[200]),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Amount",
                        style: TextStyle(color: grayscale[500]),
                      ),
                      Text(
                        "\$${widget.amount}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.032),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Promo",
                        style: TextStyle(color: grayscale[500]),
                      ),
                      Text(
                        "\$-0",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.032),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Container(
                    width: width,
                    height: 1,
                    decoration: ShapeDecoration(
                        shape: const StadiumBorder(), color: grayscale[300]),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: TextStyle(color: grayscale[500]),
                      ),
                      Text(
                        "\$${widget.amount}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.032),
                      )
                    ],
                  ),
                ],
              )),
          const SizedBox(
            height: 24,
          ),
          Container(
              padding: const EdgeInsets.all(24),
              width: width,
              decoration: ShapeDecoration(
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(80)),
                  color: grayscale[200]),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Payment Method",
                        style: TextStyle(color: grayscale[500]),
                      ),
                      Text(
                        widget.paymentMethod,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.032),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Date",
                        style: TextStyle(color: grayscale[500]),
                      ),
                      Text(
                        "Dec 15, 2024 | 10:00:27 AM",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.032),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Transaction ID",
                        style: TextStyle(color: grayscale[500]),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                          child: Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                widget.transactionId,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: width * 0.032),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset("assets/icons/Copy.svg"))
                        ],
                      ))
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Status",
                        style: TextStyle(color: grayscale[500]),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: ShapeDecoration(
                            shape: const StadiumBorder(), color: primary[500]),
                        child: Text(
                          "Paid",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.03),
                        ),
                      )
                    ],
                  ),
                ],
              )),
        ]),
      ),
    );
  }
}
