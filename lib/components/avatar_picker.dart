import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/shimmer.dart';
import 'package:galaxia/theme/theme.dart';
import 'package:image_picker/image_picker.dart';

class AvatarPicker extends StatefulWidget {
  final String? url;
  final Function(File?)? onChange;
  const AvatarPicker({super.key, this.onChange, this.url});

  @override
  AvatarPickerState createState() => AvatarPickerState();
}

class AvatarPickerState extends State<AvatarPicker> {
  File? image;
  Future pickImage() async {
    try {
      final avatar = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (avatar == null) return;
      final path = File(avatar.path);
      setState(() {
        image = path;
      });
      widget.onChange!(image);
    } on PlatformException catch (error) {
      print(error);
    }
  }

  Future takePhoto() async {
    try {
      final avatar = await ImagePicker().pickImage(source: ImageSource.camera);
      if (avatar == null) return;
      final path = File(avatar.path);
      setState(() {
        image = path;
      });
      widget.onChange!(image);
    } on PlatformException catch (error) {
      print(error);
    }
  }

  Widget showAvatar() {
    if (image != null) {
      return Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: Image.file(
          image!,
          fit: BoxFit.cover,
        ),
      );
    } else if (widget.url != null) {
      return Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: Image.network(
          widget.url!,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.32,
      height: width * 0.32,
      alignment: Alignment.bottomCenter,
      decoration:
          ShapeDecoration(shape: const CircleBorder(), color: grayscale[200]),
      child: Stack(
        children: [
          SvgPicture.asset(
            "assets/illustrations/Avatar.svg",
            height: width * 0.32,
          ),
          Positioned.fill(
            child: showAvatar(),
          ),
          Positioned(
              bottom: 0,
              right: -12,
              child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (sheet) {
                          return FittedBox(
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(24),
                                      topRight: Radius.circular(24)),
                                  border: Border.all(color: grayscale[200]!)),
                              child: Column(
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.zero),
                                          fixedSize: Size(
                                              MediaQuery.of(context).size.width,
                                              60),
                                          backgroundColor: grayscale[100],
                                          foregroundColor: grayscale[400]),
                                      onPressed: () {
                                        takePhoto();
                                      },
                                      child: Text(
                                        "Take Photo",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: grayscale[1000]),
                                      )),
                                  Container(
                                    color: grayscale[300],
                                    height: 2,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          fixedSize: Size(
                                              MediaQuery.of(context).size.width,
                                              60),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.zero),
                                          backgroundColor: grayscale[100],
                                          foregroundColor: grayscale[400]),
                                      onPressed: () {
                                        pickImage();
                                      },
                                      child: Text(
                                        "Pick from Gallery",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: grayscale[1000]),
                                      ))
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    fixedSize: const Size.fromRadius(16),
                    shape: const CircleBorder(),
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/Edit.svg",
                    width: 16,
                    fit: BoxFit.scaleDown,
                  ))),
        ],
      ),
    );
  }
}

class AvatarPickerLoading extends StatelessWidget {
  const AvatarPickerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Shimmer(
      child: ShimmerLoading(
          isLoading: true,
          child: Container(
            width: width * 0.32,
            height: width * 0.32,
            color: grayscale[200],
          )),
    );
  }
}
