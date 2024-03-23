import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/authenticate_form_button.dart';
import 'package:galaxia/components/avatar_picker.dart';
import 'package:galaxia/components/country_picker.dart';
import 'package:galaxia/screens/auth/create_new_pin.dart';
import 'package:galaxia/screens/auth/register.dart';

import 'package:galaxia/theme/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (oldValue.text.length >= newValue.text.length) {
      return newValue;
    }
    final newText = StringBuffer();
    int selectionIndex = newValue.selection.start;

    // Handle the day part (DD)
    if (newValue.text.length >= 2) {
      newText.write('${newValue.text.substring(0, 2)}/');
      if (newValue.selection.start >= 2) selectionIndex++;
    } else {
      newText.write(newValue.text);
    }

    // Handle the month part (MM)
    if (newValue.text.length >= 4) {
      newText.write('${newValue.text.substring(2, 4)}/');
      if (newValue.selection.start >= 4) selectionIndex++;
    } else {
      newText.write(newValue.text.substring(2));
    }

    // Handle the year part (YYYY)
    if (newValue.text.length >= 8) {
      newText.write(newValue.text.substring(4, 8));
    } else {
      newText.write(newValue.text.substring(4));
    }
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class ProfileSetUp extends StatefulWidget {
  const ProfileSetUp({super.key});
  @override
  ProfileSetUpState createState() => ProfileSetUpState();
}

class ProfileSetUpState extends State<ProfileSetUp> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFunctions functions = FirebaseFunctions.instance;
  FormStates formState = FormStates.Default;
  File? avatar;
  Reference storageReference = FirebaseStorage.instance.ref();
  final TextEditingController dateInputController = TextEditingController();
  final TextEditingController nameInputController = TextEditingController();
  final TextEditingController phoneInputController = TextEditingController();
  String gender = "Male";

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? validateName(String? value) {
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

  String? validateCountry(String? value) {
    if (value == null || value.isEmpty) {
      return "Country cannot be empty!";
    }
    return null;
  }

  setFile(File? value) {
    setState(() {
      avatar = value;
    });
  }

  goToCreateNewPin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (builder) => const CreateNewPin()));
  }

  submit() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        formState = FormStates.Validating;
      });
      try {
        await functions.httpsCallable("createStripeCustomer").call({
          "name": nameInputController.text,
          "phone": phoneInputController.text,
          "email": auth.currentUser?.email,
          "id": auth.currentUser?.uid
        });
        await firestore.collection("Users").doc(auth.currentUser!.uid).set({
          "Full Name": nameInputController.text,
          "Date of Birth": dateInputController.text,
          "Phone": phoneInputController.text,
          "Gender": gender,
          "Avatar": auth.currentUser?.photoURL,
          "Username": auth.currentUser?.displayName
        }, SetOptions(merge: true));

        if (avatar != null) {
          final metadata = SettableMetadata(
            contentType: 'image/jpeg',
            // contentType: 'image/png',
            customMetadata: {'picked-file-path': avatar!.path},
          );
          TaskSnapshot downloadUrl = await storageReference
              .child('${auth.currentUser!.uid}/')
              .putData(await avatar!.readAsBytes(), metadata);

          String url = await downloadUrl.ref.getDownloadURL();
          await auth.currentUser?.updatePhotoURL(url);
          await firestore
              .collection("Users")
              .doc(auth.currentUser!.uid)
              .update({"Avatar": url});
        }

        setState(() {
          formState = FormStates.Success;
        });
        goToCreateNewPin();
      } on FirebaseException catch (error) {
        print(error);
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
                "Fill Your Profile",
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
            AvatarPicker(
              url: auth.currentUser?.photoURL,
              onChange: (value) => setFile(value),
            ),
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
                    TextFormField(
                      style: Theme.of(context).textTheme.bodySmall,
                      keyboardType: TextInputType.datetime,
                      controller: dateInputController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                        DateInputFormatter()
                      ],
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 20,
                        ),
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
                    TextFormField(
                      style: Theme.of(context).textTheme.bodySmall,
                      keyboardType: TextInputType.phone,
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
                    DropdownButtonFormField(
                      dropdownColor: grayscale[200],
                      borderRadius: BorderRadius.circular(12),
                      onChanged: (value) {
                        setState(() {
                          gender = value!;
                        });
                      },
                      validator: validateGender,
                      value: gender,
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 24, right: 20),
                        child: SvgPicture.asset(
                          "assets/icons/Triangle Down.svg",
                          fit: BoxFit.scaleDown,
                          width: 20,
                        ),
                      ),
                      onSaved: (value) {
                        setState(() {
                          gender = value!;
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          child: Text("Male"),
                          value: "Male",
                        ),
                        DropdownMenuItem(
                          child: Text("Female"),
                          value: "Female",
                        )
                      ],
                      style: Theme.of(context).textTheme.bodySmall,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 20),
                        labelText: "Gender",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 24, right: 20),
                          child: SvgPicture.asset(
                            "assets/icons/User Filled.svg",
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
                        title: "Continue",
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
