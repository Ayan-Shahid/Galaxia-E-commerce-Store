import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/authenticate_form_button.dart';

import 'package:galaxia/components/country_picker.dart';
import 'package:galaxia/components/email_input.dart';
import 'package:galaxia/components/username_input.dart';
import 'package:galaxia/data/countries.dart';
import 'package:galaxia/screens/auth/profile_setup.dart';
import 'package:galaxia/screens/auth/register.dart';
import 'package:galaxia/theme/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFunctions functions = FirebaseFunctions.instance;
  FormStates formState = FormStates.Default;
  void selectCountry(String? country) {
    setState(() {
      country = country;
    });
  }

  String selectedCountry = countries[0]["code"]!;

  final TextEditingController dateInputController = TextEditingController();
  final TextEditingController nameInputController = TextEditingController();
  final TextEditingController phoneInputController = TextEditingController();
  final TextEditingController genderInputController = TextEditingController();
  final TextEditingController phoneNumberInputController =
      TextEditingController();

  final TextEditingController emailInputController = TextEditingController();
  final TextEditingController usernameInputController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your username!";
    } else if (value.length < 4) {
      return "Fullname cannot be less than 4 characters!";
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email address!";
    } else if (!value.endsWith(".com")) {
      return "Please enter a valid email address!";
    }
    return null;
  }

  String? validateUserName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your username!";
    } else if (value.length < 4) {
      return "Fullname cannot be less than 4 characters!";
    }
    return null;
  }

  String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return "Date of birth cannot be empty!";
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone number cannot be empty!";
    }
    return null;
  }

  String? validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return "Gender cannot be empty!";
    }
    return null;
  }

  submit() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        formState = FormStates.Validating;
      });
      try {
        auth.currentUser?.updateDisplayName(usernameInputController.text);

        firestore.collection("Users").doc(auth.currentUser!.uid).set({
          "Full Name": nameInputController.text,
          "Username": usernameInputController.text,
          "Country": selectedCountry,
          "Date of Birth": dateInputController.text,
          "Phone": phoneInputController.text,
          "Gender": genderInputController.text
        }, SetOptions(merge: true));

        functions.httpsCallable("updateStripeCustomer").call({
          "name": nameInputController.text,
          "phone": phoneInputController.text,
          "email": auth.currentUser?.email,
          "id": auth.currentUser?.uid
        });
        setState(() {
          formState = FormStates.Success;
        });
      } on FirebaseException {
        setState(() {
          formState = FormStates.Error;
        });
      }
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          formState = FormStates.Default;
        });
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
      builder: (context, child) => Theme(
          data: ThemeData(
              textTheme: GoogleFonts.spaceMonoTextTheme(),
              colorScheme: ColorScheme.dark(
                primary: primary[500]!,
                outline: grayscale[400],
                surface: grayscale[100]!,
                surfaceTint: grayscale[100],
              )),
          child: child!),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        // Format the selected date as needed (e.g., 'MM/dd/yyyy')
        dateInputController.text =
            "${picked.month}/${picked.day}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: AppBar(
              flexibleSpace: Container(
                color: grayscale[100],
              ),
              centerTitle: false,
              title: Text(
                "Edit Profile",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: width * 0.05),
              ),
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: SvgPicture.asset(
                    "assets/icons/Left Arrow.svg",
                    width: width * 0.08,
                  )),
            ),
          )),
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(
              height: 32,
            ),
            Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      style: Theme.of(context).textTheme.bodySmall,
                      controller: nameInputController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: validateName,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 68),
                          labelText: "Full Name",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 24, right: 20),
                            child: SvgPicture.asset(
                              "assets/icons/User Filled.svg",
                              fit: BoxFit.scaleDown,
                              width: 20,
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    UsernameInput(
                        validator: validateUserName,
                        controller: usernameInputController,
                        enabled: true),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      style: Theme.of(context).textTheme.bodySmall,
                      keyboardType: TextInputType.datetime,
                      controller: dateInputController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: validateDate,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                        DateInputFormatter()
                      ],
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 68),
                        labelText: "Date of Birth",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 24, right: 20),
                          child: SvgPicture.asset(
                            "assets/icons/User Filled.svg",
                            fit: BoxFit.scaleDown,
                            width: 20,
                          ),
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(left: 24, right: 12),
                          child: IconButton(
                              style: IconButton.styleFrom(
                                  shape: const CircleBorder()),
                              onPressed: () {
                                _selectDate(context);
                              },
                              icon: SvgPicture.asset(
                                "assets/icons/Calendar.svg",
                                fit: BoxFit.scaleDown,
                                width: 20,
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    EmailInput(
                        error: null,
                        validator: validateEmail,
                        controller: emailInputController,
                        enabled: true),
                    const SizedBox(
                      height: 24,
                    ),
                    DropdownButtonFormField(
                        onSaved: (newValue) => selectCountry(newValue),
                        dropdownColor: grayscale[200],
                        menuMaxHeight: width * 0.4,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      style: Theme.of(context).textTheme.bodySmall,
                      keyboardType: TextInputType.phone,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: validatePhone,
                      controller: phoneInputController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 68),
                        labelText: "Phone Number",
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 24, right: 0),
                          child: CountryPicker(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      style: Theme.of(context).textTheme.bodySmall,
                      controller: genderInputController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: validateGender,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 68),
                        labelText: "Gender",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 24, right: 20),
                          child: SvgPicture.asset(
                            "assets/icons/User Filled.svg",
                            fit: BoxFit.scaleDown,
                            width: 20,
                          ),
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(left: 24, right: 20),
                          child: SvgPicture.asset(
                            "assets/icons/Triangle Down.svg",
                            fit: BoxFit.scaleDown,
                            width: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: AuthenticateFormButton(
                        formState: formState,
                        title: "Update",
                        onSubmit: submit,
                      ),
                    ),
                  ],
                ))
          ],
        ),
      )),
    );
  }
}
