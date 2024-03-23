import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/screens/auth/register.dart';
import 'package:galaxia/theme/theme.dart';

class AuthenticateFormButton extends StatefulWidget {
  final FormStates formState;
  final String title;
  final void Function() onSubmit;
  const AuthenticateFormButton(
      {super.key,
      required this.formState,
      required this.title,
      required this.onSubmit});
  @override
  AuthenticateFormButtonState createState() => AuthenticateFormButtonState();
}

class AuthenticateFormButtonState extends State<AuthenticateFormButton> {
  Widget showButtonAuthStates() {
    if (widget.formState == FormStates.Default) {
      return Text(
        widget.title,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: primary[900],
            fontSize: MediaQuery.of(context).size.width * 0.03),
      );
    } else if (widget.formState == FormStates.Success)
      // ignore: curly_braces_in_flow_control_structures
      return Icon(
        Icons.check,
        color: primary[900],
      );
    else if (widget.formState == FormStates.Error) {
      return SvgPicture.asset("assets/icons/Cross.svg", width: 16);
    } else {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 4,
          valueColor: AlwaysStoppedAnimation(primary[900]),
          color: primary[900],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: widget.formState == FormStates.Default
                  ? primary[500]
                  : primary[600],
              padding: const EdgeInsets.symmetric(vertical: 20)),
          onPressed: widget.onSubmit,
          child: showButtonAuthStates()),
    );
  }
}
