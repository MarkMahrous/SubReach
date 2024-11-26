import 'package:flutter/material.dart';
import 'package:subreach/screens/vip_membership/widgets/benefits_card.dart';
import 'package:subreach/screens/vip_membership/widgets/option_vip.dart';
import 'package:subreach/shared_widgets/page_bar.dart';
import 'package:subreach/theme.dart';
import 'package:subreach/services/stripe_service.dart'; // Service to handle Stripe logic

class VipMembership extends StatefulWidget {
  const VipMembership({super.key});

  @override
  State<VipMembership> createState() => _VipMembershipState();
}

class _VipMembershipState extends State<VipMembership> {
  Future<void> handlePayment(price) async {
    await StripeService.instance.makePayment(context, price);
    setState(() {});
    await StripeService.instance.confirmPayment(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PageBar(
        title: 'VIP Membership',
        sidemenu: false,
      ),
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(16),
        color: AppColor.white,
        child: ListView(
          children: [
            BenefitsCard(),
            OptionVip(
                month: "1 Month",
                price: "4.99",
                onPressed: () async => await handlePayment("4.99")),
            OptionVip(
                month: "3 Months (Save 33%)",
                price: "9.99",
                onPressed: () async => await handlePayment("9.99")),
            OptionVip(
                month: "1 Year (Save 66%)",
                price: "19.99",
                onPressed: () async => await handlePayment("19.99")),
          ],
        ),
      ),
    );
  }
}
