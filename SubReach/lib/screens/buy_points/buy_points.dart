import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subreach/providers/points_provider.dart';
import 'package:subreach/screens/buy_points/widgets/option_card.dart';
import 'package:subreach/shared_widgets/page_bar.dart';
import 'package:subreach/theme.dart';
import 'package:subreach/services/stripe_service.dart'; // Service to handle Stripe logic

class BuyPoints extends ConsumerStatefulWidget {
  const BuyPoints({super.key});

  @override
  ConsumerState<BuyPoints> createState() => _BuyPointsState();
}

class _BuyPointsState extends ConsumerState<BuyPoints> {
  Future<void> handlePayment(price) async {
    await StripeService.instance.makePayment(context, price);
    setState(() {});
    await StripeService.instance.confirmPayment(context);
  }

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
          children: [
            OptionCard(
              points: "15,000",
              price: "0.99",
              onPressed: () async {
                final pointsNotifier = ref.read(pointsProvider.notifier);
                pointsNotifier.addPoints(100);
                await handlePayment("0.99");
                // final pointsNotifier = ref.read(pointsProvider.notifier);
                pointsNotifier.addPoints(15000);
              },
            ),
            OptionCard(
              points: "100,000",
              price: "4.99",
              onPressed: () async {
                await handlePayment("4.99");
                final pointsNotifier = ref.read(pointsProvider.notifier);
                pointsNotifier.addPoints(100000);
              },
            ),
            OptionCard(
              points: "250,000",
              price: "9.99",
              onPressed: () async {
                await handlePayment("9.99");
                final pointsNotifier = ref.read(pointsProvider.notifier);
                pointsNotifier.addPoints(250000);
              },
              // => StripeService.makePayment(context, "9.99"),
            ),
            OptionCard(
              points: "800,000",
              price: "24.99",
              onPressed: () async {
                await handlePayment("24.99");
                final pointsNotifier = ref.read(pointsProvider.notifier);
                pointsNotifier.addPoints(800000);
              },

              //  => StripeService.makePayment(context, "24.99"),
            ),
            OptionCard(
              points: "2,000,000",
              price: "49.99",
              onPressed: () async {
                await handlePayment("49.99");
                final pointsNotifier = ref.read(pointsProvider.notifier);
                pointsNotifier.addPoints(2000000);
              },

              //  => StripeService.makePayment(context, "49.99"),
            ),
            OptionCard(
              points: "5,000,000",
              price: "99.99",
              onPressed: () async {
                await handlePayment("99.99");
                final pointsNotifier = ref.read(pointsProvider.notifier);
                pointsNotifier.addPoints(5000000);
              },
              //  => StripeService.makePayment(context, "99.99"),
            ),
          ],
        ),
      ),
    );
  }
}
