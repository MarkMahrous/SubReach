import 'package:flutter/material.dart';
import 'package:subreach/screens/buy_points/widgets/option_card.dart';
import 'package:subreach/shared_widgets/page_bar.dart';
import 'package:subreach/theme.dart';

class BuyPoints extends StatelessWidget {
  const BuyPoints({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PageBar(
        title: 'Buy Points',
        sidemenu: false,
      ),
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(16),
        color: AppColor.white,
        child: ListView(
          children: const [
            OptionCard(points: "15,000", price: "0.99"),
            OptionCard(points: "100,000", price: "4.99"),
            OptionCard(points: "250,000", price: "9.99"),
            OptionCard(points: "800,000", price: "24.99"),
            OptionCard(points: "2,000,000", price: "49.99"),
            OptionCard(points: "5,000,000", price: "99.99"),
          ],
        ),
      ),
    );
  }
}
