import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/authenticate_form_button.dart';
import 'package:galaxia/components/check_box.dart';
import 'package:galaxia/data/countries.dart';
import 'package:galaxia/screens/auth/register.dart';
import 'package:galaxia/store/address_book_state.dart';
import 'package:galaxia/store/app_state.dart';
import 'package:galaxia/store/galaxia_store.dart';
import 'package:galaxia/theme/theme.dart';
import 'package:redux/redux.dart';

class AddNewAddress extends StatefulWidget {
  const AddNewAddress({Key? key}) : super(key: key);

  @override
  AddNewAddressState createState() => AddNewAddressState();
}

class AddNewAddressState extends State<AddNewAddress> {
  final TextEditingController nameInputController = TextEditingController();
  bool isDefault = false;
  toggleDefault() {
    setState(() {
      isDefault = !isDefault;
    });
  }

  String selectedCountry = countries[0]["code"]!;
  final GlobalKey<FormState> formKey = GlobalKey();
  FormStates formState = FormStates.Default;
  FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController stateInputController = TextEditingController();
  final TextEditingController cityInputController = TextEditingController();
  final TextEditingController postalCodeInputController =
      TextEditingController();
  final TextEditingController line1InputController = TextEditingController();
  final TextEditingController line2InputController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  void selectCountry(String? country) {
    setState(() {
      country = country;
    });
  }

  Future<String?> saveAddressToFirebase() async {
    try {
      return await firestore.collection("Address's").add({
        "ID": auth.currentUser!.uid,
        "Name": nameInputController.text,
        "Country": selectedCountry,
        "State": stateInputController.text,
        "City": cityInputController.text,
        "Postal Code": postalCodeInputController.text,
        "Line 1": line1InputController.text,
        "Line 2": line2InputController.text,
        "Is Default": isDefault
      }).then((value) => value.id);
    } catch (error) {
      setState(() {
        formState = FormStates.Error;
      });
      throw error;
    }
  }

  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return "This field cannot be empty!";
    }

    return null;
  }

  void onSubmit() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        formState = FormStates.Validating;
      });
      String? uid = await saveAddressToFirebase();
      galaxiaStore.dispatch((Store<AppState> store) {
        store.dispatch(AddressBookStateAction(
            type: AddressBookStateActions.add,
            payload: AddressBookItem(
                id: auth.currentUser!.uid,
                uid: uid,
                name: nameInputController.text,
                country: selectedCountry,
                state: stateInputController.text,
                city: cityInputController.text,
                postalCode: postalCodeInputController.text,
                line1: line1InputController.text,
                line2: line2InputController.text,
                isDefault: isDefault)));
      });
      setState(() {
        formState = FormStates.Success;
      });
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          formState = FormStates.Default;
        });
        Navigator.of(context).pop();
      });
    }
  }

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
                "Add New Address",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: width * 0.05),
              ),
            ),
          )),
      body: SafeArea(
          child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Name",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: nameInputController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => validateInput(value),
                      decoration: InputDecoration(
                          alignLabelWithHint: true,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 24, right: 16),
                            child: SvgPicture.asset(
                              "assets/icons/Home Filled.svg",
                              width: width * 0.05,
                            ),
                          ),
                          labelText: "Name"),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const Text(
                      "Address Details",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    DropdownButtonFormField(
                        onSaved: (newValue) => selectCountry(newValue),
                        dropdownColor: grayscale[200],
                        menuMaxHeight: width * 0.4,
                        borderRadius: BorderRadius.circular(12),
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          labelText: "Country",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 24, right: 16),
                            child: SvgPicture.asset(
                              "assets/icons/Location.svg",
                              width: width * 0.05,
                            ),
                          ),
                        ),
                        items: List.generate(
                            countries.length,
                            (index) => DropdownMenuItem(
                                value: countries[index]["code"],
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/flags/${icons[index]}",
                                      width: width * 0.06,
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    SizedBox(
                                      width: width * 0.5,
                                      child: Text(
                                        '${countries[index]["name"]}',
                                        style: const TextStyle(
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    )
                                  ],
                                ))),
                        onChanged: (v) {}),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => validateInput(value),
                      controller: stateInputController,
                      decoration: InputDecoration(
                          alignLabelWithHint: true,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 24, right: 16),
                            child: SvgPicture.asset(
                              "assets/icons/Location.svg",
                              width: width * 0.05,
                            ),
                          ),
                          labelText: "State"),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: cityInputController,
                      validator: (value) => validateInput(value),
                      decoration: InputDecoration(
                          alignLabelWithHint: true,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 24, right: 16),
                            child: SvgPicture.asset(
                              "assets/icons/Location.svg",
                              width: width * 0.05,
                            ),
                          ),
                          labelText: "City"),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: postalCodeInputController,
                      validator: (value) => validateInput(value),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          alignLabelWithHint: true,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 24, right: 16),
                            child: SvgPicture.asset(
                              "assets/icons/Location.svg",
                              width: width * 0.05,
                            ),
                          ),
                          labelText: "Postal Code"),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => validateInput(value),
                      controller: line1InputController,
                      decoration: InputDecoration(
                          alignLabelWithHint: true,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 24, right: 16),
                            child: SvgPicture.asset(
                              "assets/icons/Location.svg",
                              width: width * 0.05,
                            ),
                          ),
                          labelText: "Line 1"),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => validateInput(value),
                      controller: line2InputController,
                      decoration: InputDecoration(
                          alignLabelWithHint: true,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 24, right: 16),
                            child: SvgPicture.asset(
                              "assets/icons/Location.svg",
                              width: width * 0.05,
                            ),
                          ),
                          labelText: "Line 2"),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        CheckBox(
                          selected: isDefault,
                          onTap: toggleDefault,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Make this as the default address",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.032),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    AuthenticateFormButton(
                        formState: formState, title: "Add", onSubmit: onSubmit)
                  ],
                ),
              ))),
    );
  }
}
