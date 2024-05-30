import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/components/popup.dart';

class SpinnerWidget extends StatefulWidget {
  @override
  _SpinnerWidgetState createState() => _SpinnerWidgetState();
}

class _SpinnerWidgetState extends State<SpinnerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        child: SvgPicture.asset(
          "assets/illustrations/Spinner.svg",
          width: MediaQuery.of(context).size.width * 0.1,
        ),
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 2.0 * 3.141592653589793,
            child: child,
          );
        },
      ),
    );
  }
}

class GoogleAuthLoadingPopUp extends StatelessWidget {
  const GoogleAuthLoadingPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return PopUp(
        borderRadius: 124,
        padding:
            const EdgeInsets.only(top: 32, left: 32, right: 32, bottom: 32),
        content: Column(
          children: [
            SvgPicture.asset(
              "assets/illustrations/Sign In.svg",
              width: MediaQuery.of(context).size.width * 0.6,
            ),
            const SizedBox(
              height: 24,
            ),
            Text("Authenticating!",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 24,
            ),
            SpinnerWidget()
          ],
        ));
  }
}
