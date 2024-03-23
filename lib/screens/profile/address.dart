import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/address_card.dart';
import 'package:galaxia/screens/profile/add_new_address.dart';
import 'package:galaxia/store/address_book_state.dart';
import 'package:galaxia/store/app_state.dart';

import 'package:galaxia/theme/theme.dart';

class Address extends StatefulWidget {
  const Address({Key? key}) : super(key: key);

  @override
  AddressState createState() => AddressState();
}

class AddressState extends State<Address> {
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
                centerTitle: false,
                leading: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: SvgPicture.asset(
                      "assets/icons/Left Arrow.svg",
                      width: width * 0.08,
                    )),
                title: Text(
                  "Address",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: width * 0.05),
                ),
              ),
            )),
        body: SingleChildScrollView(
          child: StoreBuilder<AppState>(
              builder: (galaxiastorecontext, galaxiastore) {
            return SizedBox(
              height: MediaQuery.of(context).size.height - (width * 0.36),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  galaxiastore.state.addressBook.items.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/illustrations/No Data.svg",
                              width: width * 0.8,
                            ),
                            SizedBox(
                              width: width * 0.6,
                              child: Text("Your address book is empty!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: width * 0.05)),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            SizedBox(
                              width: width * 0.6,
                              child: Text("You don't have any address saved!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: width * 0.028)),
                            ),
                          ],
                        )
                      : SizedBox(
                          height: width,
                          child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.all(24),
                              itemCount:
                                  galaxiastore.state.addressBook.items.length,
                              itemBuilder: (context, index) {
                                AddressBookItem item =
                                    galaxiastore.state.addressBook.items[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 24),
                                  child: AddressCard(
                                    address: item,
                                  ),
                                );
                              }),
                        ),
                  Container(
                      padding:
                          const EdgeInsets.only(left: 24, right: 24, top: 24),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32)),
                          border:
                              Border(top: BorderSide(color: grayscale[200]!))),
                      width: width,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const AddNewAddress()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/Plus.svg",
                                width: 16,
                                height: 16,
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Text(
                                "Add New Address",
                                style: TextStyle(color: primary[900]),
                              )
                            ],
                          )))
                ],
              ),
            );
          }),
        ));
  }
}
