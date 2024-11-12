import 'package:flutter/material.dart';
import 'package:subreach/theme.dart';

class BenefitsCard extends StatelessWidget {
  const BenefitsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: Card(
        elevation: 2,
        color: AppColor.white,
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Image.asset("assets/images/vip.png")),
              myText(content: "BENEFITS", fontSize: 22),
              myText(content: "25% Off on Campaigns"),
              myText(content: "Increased Daily Limits (+100)"),
              myText(content: "Remove Ads"),
            ],
          ),
        ),
      ),
    );
  }
}

Widget myText({required String content, double fontSize = 16}) {
  return Text(
    content,
    style: TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    ),
  );
}
