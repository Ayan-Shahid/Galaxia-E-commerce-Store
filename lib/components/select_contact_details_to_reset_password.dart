import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/theme/theme.dart';

enum DetailsType { phone, email }

class SelectContactDetailsToResetPassword extends StatefulWidget {
  final Function(DetailsType type)? onChange;
  const SelectContactDetailsToResetPassword({super.key, this.onChange});

  @override
  SelectContactDetailsToResetPasswordState createState() =>
      SelectContactDetailsToResetPasswordState();
}

class SelectContactDetailsToResetPasswordState
    extends State<SelectContactDetailsToResetPassword> {
  bool isSelected = true;

  void selectEmail() {
    setState(() {
      isSelected = true;
    });
    widget.onChange!(DetailsType.email);
  }

  void selectSMS() {
    setState(() {
      isSelected = false;
    });
    widget.onChange!(DetailsType.phone);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
          onPressed: selectSMS,
          style: OutlinedButton.styleFrom(
              backgroundColor: isSelected ? grayscale[100] : primary[100],
              foregroundColor: isSelected ? grayscale[600] : primary[200],
              side: BorderSide(
                  color: isSelected
                      ? grayscale[200] ?? Colors.black45
                      : primary[500] ?? Colors.blue),
              shape: const StadiumBorder(),
              padding: const EdgeInsets.all(24)),
          child: Row(
            children: [
              Container(
                width: 72,
                height: 72,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? grayscale[200] : primary[500]),
                child: SvgPicture.asset("assets/icons/Chat.svg",
                    color: isSelected ? grayscale[1000] : primary[1000]),
              ),
              const SizedBox(
                width: 24,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Via SMS",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isSelected ? grayscale[500] : primary[500]),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "+** *** *******",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? grayscale[1000] : primary[900]),
                  )
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        OutlinedButton(
          onPressed: selectEmail,
          style: OutlinedButton.styleFrom(
              backgroundColor: !isSelected ? grayscale[100] : primary[100],
              foregroundColor: !isSelected ? grayscale[600] : primary[200],
              side: BorderSide(
                  color: !isSelected
                      ? grayscale[200] ?? Colors.black45
                      : primary[500] ?? Colors.blue),
              shape: const StadiumBorder(),
              padding: const EdgeInsets.all(24)),
          child: Row(
            children: [
              Container(
                width: 72,
                height: 72,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: !isSelected ? grayscale[200] : primary[500]),
                child: SvgPicture.asset("assets/icons/Email Filled.svg",
                    color: !isSelected ? grayscale[1000] : primary[1000]),
              ),
              const SizedBox(
                width: 24,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Via Email",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: !isSelected ? grayscale[500] : primary[500]),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "****@gmail.com",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: !isSelected ? grayscale[1000] : primary[1000]),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
