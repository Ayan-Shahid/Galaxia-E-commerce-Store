import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/popup.dart';
import 'package:galaxia/data/countries.dart';
import 'package:galaxia/theme/theme.dart';

class CountryPicker extends StatefulWidget {
  const CountryPicker({super.key});

  @override
  CountryPickerState createState() => CountryPickerState();
}

class CountryPickerState extends State<CountryPicker> {
  int current = 0;
  select(int index) {
    setState(() {
      current = index;
    });
  }

  @override
  Widget build(BuildContext) {
    return Container(
      child: FittedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/flags/${icons[current]}",
              width: 16,
              fit: BoxFit.scaleDown,
            ),
            IconButton(
                onPressed: () {
                  showCupertinoModalPopup(
                      context: context,
                      builder: (popup) => PopUp(
                          borderRadius: 24,
                          padding: const EdgeInsets.all(24),
                          content: Column(
                            children: [
                              Material(
                                  color: Colors.transparent,
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: TextField(
                                      decoration: InputDecoration(
                                          hintText: "Search",
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 24, right: 20),
                                            child: SvgPicture.asset(
                                                "assets/icons/Search.svg"),
                                          )),
                                    ),
                                  )),
                              const SizedBox(
                                height: 24,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: ListView.builder(
                                    itemCount: countries.length,
                                    itemBuilder: (listcontext, index) =>
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 24),
                                          child: Material(
                                            shape: StadiumBorder(
                                                side: BorderSide(
                                                    color: grayscale[400]!)),
                                            color: grayscale[200],
                                            clipBehavior: Clip.antiAlias,
                                            child: InkWell(
                                              onTap: () {
                                                select(index);
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 24,
                                                        vertical: 12),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/flags/${icons[index]}",
                                                      width: 24,
                                                    ),
                                                    const SizedBox(
                                                      width: 16,
                                                    ),
                                                    Text(
                                                        countries[index]
                                                            ["dial_code"]!,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall),
                                                    const SizedBox(
                                                      width: 16,
                                                    ),
                                                    Text(
                                                        countries[index]
                                                            ["name"]!,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                              )
                            ],
                          )));
                },
                icon: SvgPicture.asset(
                  "assets/icons/Carrot Down.svg",
                  width: 16,
                )),
            Text(
              '${countries[current]["dial_code"]} ',
              style: TextStyle(fontSize: 12, color: grayscale[1000]),
            ),
          ],
        ),
      ),
    );
  }
}
