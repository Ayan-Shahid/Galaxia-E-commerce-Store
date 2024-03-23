import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:galaxia/store/galaxia_product.dart';
import 'package:galaxia/store/galaxia_store.dart';
import 'package:galaxia/theme/theme.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Invoice extends pw.Document {
  final pageWidth = PdfPageFormat.standard.width;
  final pageHeight = PdfPageFormat.standard.height;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final headers = ['Date', 'Description', 'Price', 'QTY.', 'Total'];

  Invoice();

  build(List<GalaxiaCartProduct> items) async {
    final pdfLogo = await rootBundle.loadString('assets/icons/Logo.svg');
    final pdfEmailIcon =
        await rootBundle.loadString('assets/icons/Email Filled.svg');
    final pdfLocationIcon =
        await rootBundle.loadString('assets/icons/Location.svg');

    final pdfFooter =
        await rootBundle.loadString('assets/illustrations/Invoice Footer.svg');
    final pdfHeader =
        await rootBundle.loadString('assets/illustrations/Invoice Header.svg');

    const itemsPerPage = 4;
    final pageCount = (items.length / itemsPerPage).ceil();

    for (var pageIndex = 0; pageIndex < pageCount; pageIndex++) {
      final startIndex = pageIndex * itemsPerPage;

      final endIndex = (startIndex + itemsPerPage < items.length)
          ? startIndex + itemsPerPage
          : items.length;

      final pageItems = items.sublist(startIndex, endIndex);

      addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.zero,
          build: (pw.Context context) {
            return pw.Container(
              width: pageWidth,
              height: pageHeight,
              color: PdfColor.fromInt(grayscale[100]!.value),
              child: pw.Column(children: [
                pw.Stack(children: [
                  pw.SvgImage(
                      svg: pdfHeader,
                      width: pageWidth,
                      fit: pw.BoxFit.fill,
                      height: pageWidth * 0.28),
                  pw.Positioned(
                    top: pageWidth * 0.12,
                    left: pageWidth * 0.03,
                    child: pw.Container(
                        margin: pw.EdgeInsets.only(left: 24),
                        child: pw.Row(children: [
                          pw.SvgImage(svg: pdfLogo, width: pageWidth * 0.06),
                          pw.SizedBox(width: 8),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text("Galaxia",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: pageWidth * 0.028,
                                        color: PdfColors.white)),
                                pw.Text("E-comerce Marketplace",
                                    style: pw.TextStyle(
                                        fontSize: pageWidth * 0.014,
                                        color: PdfColors.white))
                              ])
                        ])),
                  ),
                  pw.Positioned(
                      right: pageWidth * 0.06,
                      top: pageWidth * 0.04,
                      child: pw.Container(
                          width: pageWidth * 0.176,
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text("INVOICE",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColor.fromInt(
                                            primary[500]!.value),
                                        fontSize: pageWidth * 0.04)),
                                pw.SizedBox(height: 8),
                                pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Text("Invoice Number: ",
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold,
                                              color: PdfColor.fromInt(
                                                  grayscale[1000]!.value),
                                              fontSize: pageWidth * 0.012)),
                                      pw.SizedBox(height: 4),
                                      pw.Text("123456",
                                          style: pw.TextStyle(
                                              color: PdfColor.fromInt(
                                                  grayscale[1000]!.value),
                                              fontSize: pageWidth * 0.012))
                                    ]),
                                pw.SizedBox(height: 4),
                                pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Text("Account No: ",
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold,
                                              color: PdfColor.fromInt(
                                                  grayscale[1000]!.value),
                                              fontSize: pageWidth * 0.012)),
                                      pw.Text("1234 1512 4123",
                                          style: pw.TextStyle(
                                              color: PdfColor.fromInt(
                                                  grayscale[1000]!.value),
                                              fontSize: pageWidth * 0.012))
                                    ]),
                                pw.SizedBox(height: 4),
                                pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Text("Invoice Date: ",
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold,
                                              color: PdfColor.fromInt(
                                                  grayscale[1000]!.value),
                                              fontSize: pageWidth * 0.012)),
                                      pw.Text("April 05, 2020",
                                          style: pw.TextStyle(
                                              color: PdfColor.fromInt(
                                                  grayscale[1000]!.value),
                                              fontSize: pageWidth * 0.012))
                                    ])
                              ])))
                ]),
                pw.Container(
                    padding: pw.EdgeInsets.all(32),
                    child: pw.Column(children: [
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Container(
                                width: pageWidth * 0.2,
                                child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text("INVOICE TO:",
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold,
                                              color: PdfColor.fromInt(
                                                  grayscale[1000]!.value),
                                              fontSize: pageWidth * 0.016)),
                                      pw.SizedBox(height: 4),
                                      pw.Text(
                                          "${auth.currentUser?.displayName}.",
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold,
                                              color: PdfColor.fromInt(
                                                  grayscale[1000]!.value),
                                              fontSize: pageWidth * 0.028)),
                                      pw.SizedBox(height: 8),
                                      pw.Text("Managing Director, Company ltd.",
                                          style: pw.TextStyle(
                                              color: PdfColor.fromInt(
                                                  grayscale[1000]!.value),
                                              fontSize: pageWidth * 0.012)),
                                      pw.SizedBox(height: 4),
                                      pw.Text("Phone: +123 4567 8910",
                                          style: pw.TextStyle(
                                              color: PdfColor.fromInt(
                                                  grayscale[1000]!.value),
                                              fontSize: pageWidth * 0.012)),
                                      pw.SizedBox(height: 4),
                                      pw.Text("Email: example@gmail.com",
                                          style: pw.TextStyle(
                                              color: PdfColor.fromInt(
                                                  grayscale[1000]!.value),
                                              fontSize: pageWidth * 0.012))
                                    ])),
                            pw.Container(
                                width: pageWidth * 0.176,
                                child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text("Payment Method",
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold,
                                              color: PdfColor.fromInt(
                                                  grayscale[1000]!.value),
                                              fontSize: pageWidth * 0.018)),
                                      pw.SizedBox(height: 8),
                                      pw.Row(
                                          mainAxisAlignment:
                                              pw.MainAxisAlignment.spaceBetween,
                                          children: [
                                            pw.Text("Account No: ",
                                                style: pw.TextStyle(
                                                    fontWeight:
                                                        pw.FontWeight.bold,
                                                    color: PdfColor.fromInt(
                                                        grayscale[1000]!.value),
                                                    fontSize:
                                                        pageWidth * 0.012)),
                                            pw.SizedBox(height: 4),
                                            pw.Text("1244 5123 322",
                                                style: pw.TextStyle(
                                                    color: PdfColor.fromInt(
                                                        grayscale[1000]!.value),
                                                    fontSize:
                                                        pageWidth * 0.012))
                                          ]),
                                      pw.SizedBox(height: 4),
                                      pw.Row(
                                          mainAxisAlignment:
                                              pw.MainAxisAlignment.spaceBetween,
                                          children: [
                                            pw.Text("Account Name: ",
                                                style: pw.TextStyle(
                                                    fontWeight:
                                                        pw.FontWeight.bold,
                                                    color: PdfColor.fromInt(
                                                        grayscale[1000]!.value),
                                                    fontSize:
                                                        pageWidth * 0.012)),
                                            pw.Text(
                                                "${auth.currentUser?.displayName}",
                                                style: pw.TextStyle(
                                                    color: PdfColor.fromInt(
                                                        grayscale[1000]!.value),
                                                    fontSize:
                                                        pageWidth * 0.012))
                                          ]),
                                      pw.SizedBox(height: 4),
                                      pw.Row(
                                          mainAxisAlignment:
                                              pw.MainAxisAlignment.spaceBetween,
                                          children: [
                                            pw.Text("Branch Name: ",
                                                style: pw.TextStyle(
                                                    fontWeight:
                                                        pw.FontWeight.bold,
                                                    color: PdfColor.fromInt(
                                                        grayscale[1000]!.value),
                                                    fontSize:
                                                        pageWidth * 0.012)),
                                            pw.Text("XYZ",
                                                style: pw.TextStyle(
                                                    color: PdfColor.fromInt(
                                                        grayscale[1000]!.value),
                                                    fontSize:
                                                        pageWidth * 0.012))
                                          ])
                                    ]))
                          ]),
                      pw.SizedBox(height: 24),
                      pw.TableHelper.fromTextArray(
                          context: context,
                          headers: headers,
                          data: pageItems.map((e) {
                            final now = DateTime.now();

// Define month names mapping
                            const List<String> monthNames = [
                              'Jan',
                              'Feb',
                              'Mar',
                              'Apr',
                              'May',
                              'Jun',
                              'Jul',
                              'Aug',
                              'Sep',
                              'Oct',
                              'Nov',
                              'Dec'
                            ];

// Format the date
                            final formattedDate =
                                '${monthNames[now.month - 1]} ${now.day}, ${now.year}';
                            return [
                              formattedDate,
                              e.name,
                              e.price,
                              e.quantity,
                              (e.price! * e.quantity!.toDouble())
                            ];
                          }).toList(),
                          headerStyle: pw.TextStyle(
                              color: PdfColor.fromInt(grayscale[1000]!.value),
                              fontWeight: pw.FontWeight.bold),
                          cellStyle: pw.TextStyle(
                              color: PdfColor.fromInt(grayscale[1000]!.value)),
                          headerDecoration: pw.BoxDecoration(
                              color: PdfColor.fromInt(primary[500]!.value)),
                          cellAlignments: {
                            0: pw.Alignment.centerLeft,
                            1: pw.Alignment.centerLeft,
                            2: pw.Alignment.center,
                            3: pw.Alignment.center,
                            4: pw.Alignment.center,
                          },
                          border: pw.TableBorder(
                              verticalInside: pw.BorderSide.none),
                          headerPadding: pw.EdgeInsets.only(left: 16),
                          cellPadding: pw.EdgeInsets.only(left: 16),
                          cellDecoration: (index, data, rowNum) =>
                              pw.BoxDecoration(
                                border: pw.TableBorder(),
                              ),
                          cellHeight: pageWidth * 0.07,
                          rowDecoration: pw.BoxDecoration(
                              color: PdfColor.fromInt(grayscale[100]!.value)),
                          oddRowDecoration: pw.BoxDecoration(
                              color: PdfColor.fromInt(grayscale[200]!.value))),
                      pw.SizedBox(height: 32),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.SizedBox(
                                width: pageWidth * 0.34,
                                child: pw.Column(children: [
                                  pw.Text("Thank You For Your Business",
                                      style: pw.TextStyle(
                                        color: PdfColor.fromInt(
                                            grayscale[1000]!.value),
                                        fontWeight: pw.FontWeight.bold,
                                      )),
                                  pw.SizedBox(height: 16),
                                  pw.Row(children: [
                                    pw.Container(
                                        width: pageWidth * 0.03,
                                        height: pageWidth * 0.03,
                                        color: PdfColor.fromInt(
                                            primary[500]!.value),
                                        child: null),
                                    pw.SizedBox(width: 8),
                                    pw.Text("+123 4523 4343",
                                        style: pw.TextStyle(
                                            color: PdfColor.fromInt(
                                                grayscale[1000]!.value)))
                                  ]),
                                  pw.SizedBox(height: 4),
                                  pw.Row(children: [
                                    pw.Container(
                                        width: pageWidth * 0.03,
                                        padding: pw.EdgeInsets.all(2),
                                        height: pageWidth * 0.03,
                                        color: PdfColor.fromInt(
                                            primary[500]!.value),
                                        child: pw.SvgImage(
                                          svg: pdfEmailIcon,
                                        )),
                                    pw.SizedBox(width: 8),
                                    pw.Text("example@gmail.com",
                                        style: pw.TextStyle(
                                            color: PdfColor.fromInt(
                                                grayscale[1000]!.value))),
                                  ]),
                                  pw.SizedBox(height: 4),
                                  pw.Row(children: [
                                    pw.Container(
                                        padding: pw.EdgeInsets.all(2),
                                        width: pageWidth * 0.03,
                                        height: pageWidth * 0.03,
                                        color: PdfColor.fromInt(
                                            primary[500]!.value),
                                        child: pw.SvgImage(
                                          svg: pdfLocationIcon,
                                        )),
                                    pw.SizedBox(width: 8),
                                    pw.Text("Your Location Here",
                                        style: pw.TextStyle(
                                            color: PdfColor.fromInt(
                                                grayscale[1000]!.value)))
                                  ])
                                ])),
                            pw.SizedBox(
                                width: pageWidth * 0.24,
                                child: pw.Column(children: [
                                  pw.Row(
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Text("Subtotal: ",
                                            style: pw.TextStyle(
                                                color: PdfColor.fromInt(
                                                    grayscale[1000]!.value),
                                                fontSize: pageWidth * 0.012)),
                                        pw.SizedBox(height: 4),
                                        pw.Text(
                                            "\$${galaxiaStore.state.cart.subTotal}",
                                            style: pw.TextStyle(
                                                fontWeight: pw.FontWeight.bold,
                                                color: PdfColor.fromInt(
                                                    grayscale[1000]!.value),
                                                fontSize: pageWidth * 0.012))
                                      ]),
                                  pw.SizedBox(height: 4),
                                  pw.Row(
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Text("Discount: ",
                                            style: pw.TextStyle(
                                                color: PdfColor.fromInt(
                                                    grayscale[1000]!.value),
                                                fontSize: pageWidth * 0.012)),
                                        pw.Text("00.00",
                                            style: pw.TextStyle(
                                                fontWeight: pw.FontWeight.bold,
                                                color: PdfColor.fromInt(
                                                    grayscale[1000]!.value),
                                                fontSize: pageWidth * 0.012))
                                      ]),
                                  pw.SizedBox(height: 4),
                                  pw.Row(
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Text("Tax (10%): ",
                                            style: pw.TextStyle(
                                                color: PdfColor.fromInt(
                                                    grayscale[1000]!.value),
                                                fontSize: pageWidth * 0.012)),
                                        pw.Text(
                                            "\$${galaxiaStore.state.cart.subTotal}",
                                            style: pw.TextStyle(
                                                fontWeight: pw.FontWeight.bold,
                                                color: PdfColor.fromInt(
                                                    grayscale[1000]!.value),
                                                fontSize: pageWidth * 0.012))
                                      ]),
                                  pw.SizedBox(height: 16),
                                  pw.Container(
                                      color:
                                          PdfColor.fromInt(primary[500]!.value),
                                      padding: pw.EdgeInsets.all(12),
                                      width: pageWidth * 0.3,
                                      child: pw.Row(
                                          mainAxisAlignment:
                                              pw.MainAxisAlignment.spaceBetween,
                                          children: [
                                            pw.Text("Total: ",
                                                style: pw.TextStyle(
                                                    color: PdfColor.fromInt(
                                                        primary[900]!.value),
                                                    fontWeight:
                                                        pw.FontWeight.bold)),
                                            pw.Text(
                                                "\$${galaxiaStore.state.cart.subTotal}",
                                                style: pw.TextStyle(
                                                    color: PdfColor.fromInt(
                                                        primary[900]!.value),
                                                    fontWeight:
                                                        pw.FontWeight.bold))
                                          ]))
                                ]))
                          ]),
                      pw.SizedBox(
                        height: 40,
                      ),
                      pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.SizedBox(
                                width: pageWidth * 0.4,
                                child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text("Terms & Conditions:",
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold,
                                              color: PdfColor.fromInt(
                                                  grayscale[1000]!.value))),
                                      pw.SizedBox(height: 4),
                                      pw.Text(
                                          "flasjdfjaslfjlkasdjalskdjflaksdjfl;kasdjfsdjfklsadjfl;sadfjklasdjfklsdafjasdkljfaklsdjfalsdjf;asdjfas;ffasd;akjas;lfj",
                                          style: pw.TextStyle(
                                              color: PdfColor.fromInt(
                                                  grayscale[1000]!.value)))
                                    ])),
                            pw.Spacer(),
                            pw.Column(children: [
                              pw.SizedBox(height: pageWidth * 0.1),
                              pw.Container(
                                  width: pageWidth * 0.3,
                                  height: 1,
                                  color:
                                      PdfColor.fromInt(grayscale[1000]!.value)),
                              pw.SizedBox(height: 8),
                              pw.Text("Your Name & Signature",
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColor.fromInt(
                                          grayscale[1000]!.value))),
                              pw.SizedBox(height: 4),
                              pw.Text("Account Manager",
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      color: PdfColor.fromInt(
                                          grayscale[1000]!.value)))
                            ])
                          ]),
                    ])),
                pw.Spacer(),
                pw.SvgImage(
                    svg: pdfFooter,
                    width: pageWidth,
                    height: pageWidth * 0.06,
                    fit: pw.BoxFit.fill)
              ]),
            ); // Center
          }));
    }
  }
}
