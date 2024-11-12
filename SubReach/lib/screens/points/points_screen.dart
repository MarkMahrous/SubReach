import 'package:flutter/material.dart';
import 'package:subreach/screens/buy_points/buy_points.dart';
import 'package:subreach/screens/points/widgets/feature_card.dart';
import 'package:subreach/screens/vip_membership/vip_membership.dart';
import 'package:subreach/theme.dart';

class PointsScreen extends StatefulWidget {
  const PointsScreen({super.key});

  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.white,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FeatureCard(
            action: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const BuyPoints(),
                ),
              );
            },
            text: "BUY POINTS",
            image: 'assets/images/cart.png',
          ),
          const SizedBox(height: 16),
          FeatureCard(
            action: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const VipMembership(),
                ),
              );
            },
            text: "VIP MEMBERSHIP",
            image: 'assets/images/vip.png',
          ),
          const SizedBox(height: 16),
          FeatureCard(
            action: () {},
            text: "LEAVE FEEBACK",
            image: 'assets/images/subreach.png',
          ),
        ],
      ),
    );
  }
}
