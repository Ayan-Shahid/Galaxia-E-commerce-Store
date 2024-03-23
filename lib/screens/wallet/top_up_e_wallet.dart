import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxia/screens/wallet/confirm_top_up.dart';
import 'package:galaxia/screens/wallet/select_top_up_method.dart';
import 'package:galaxia/theme/theme.dart';

class TopUpEWallet extends StatefulWidget {
  const TopUpEWallet({Key? key}) : super(key: key);

  @override
  TopUpEWalletState createState() => TopUpEWalletState();
}

class TopUpEWalletState extends State<TopUpEWallet> {
  final TextEditingController controller =
      TextEditingController(text: 10.toString());
  final List<int> options = [10, 20, 50, 100, 200, 250, 500, 750, 1000];

  int selected = 0;
  select(int index) {
    setState(() {
      selected = index;
    });
    controller.text = options[selected].toString();
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
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: SvgPicture.asset(
                    "assets/icons/Left Arrow.svg",
                    width: width * 0.08,
                  )),
              title: const Text(
                "Top Up E-Wallet",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Center(
              child: Text(
                "Enter the amount you want to Top-Up",
                style: TextStyle(fontSize: width * 0.034),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            TextFormField(
              textAlign: TextAlign.center,
              controller: controller,
              style: TextStyle(
                  fontSize: width * 0.12, fontWeight: FontWeight.bold),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: grayscale[600],
                    fontSize: width * 0.12,
                  ),
                  hintText: "Amount",
                  prefixText: "\$",
                  prefixStyle: TextStyle(
                    fontSize: width * 0.12,
                    fontWeight: FontWeight.bold,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 56, vertical: 24)),
            ),
            const SizedBox(
              height: 24,
            ),
            GridView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: width * 0.005,
                    mainAxisSpacing: 0,
                    crossAxisCount: 3,
                    crossAxisSpacing: 0),
                itemBuilder: (context, index) {
                  return FilterChip(
                    onSelected: (value) {
                      select(index);
                    },
                    selectedColor: primary[100],
                    padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                    label: Text("\$${options[index]}"),
                    selected: selected == index,
                    showCheckmark: false,
                    backgroundColor: grayscale[100],
                    side: BorderSide(
                        color: selected == index
                            ? primary[500] ?? Colors.blue
                            : grayscale[200] ?? Colors.black38),
                    shape: const StadiumBorder(),
                  );
                }),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SelectTopUpMethod(
                            amount: double.parse(controller.text),
                          )));
                },
                style: ElevatedButton.styleFrom(
                    foregroundColor: primary[900],
                    elevation: 0.0,
                    fixedSize: Size(width, width * 0.14)),
                child: Text(
                  "Continue",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    );
  }
}
