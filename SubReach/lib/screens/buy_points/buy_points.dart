import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subreach/providers/points_provider.dart';
import 'package:subreach/screens/buy_points/widgets/option_card.dart';
import 'package:subreach/shared_widgets/page_bar.dart';
import 'package:subreach/theme.dart';
import 'package:subreach/services/stripe_service.dart'; // Service to handle Stripe logic
import 'package:http/http.dart' as http;

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

  String? getUserEmail() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }

  Future<String?> getUserId() async {
    final userEmail = getUserEmail();
    final url = Uri.parse(
        'http://192.168.0.101:3000/api/users/create?email=$userEmail');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('userId');
        print(data[0]['_id']);
        return data[0]['_id'];
      } else {
        print('Failed to fetch user ID. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching user ID: $e');
      return null;
    }
  }

  void updateUserPoints(int points) async {
    final userId = await getUserId();
    await http.patch(
      Uri.parse('http://192.168.0.101:3000/api/users/create?id=$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'points': points,
      }),
    );
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
                await handlePayment("0.99");
                final pointsNotifier = ref.read(pointsProvider.notifier);
                pointsNotifier.addPoints(15000);
                updateUserPoints(15000);
              },
            ),
            OptionCard(
              points: "100,000",
              price: "4.99",
              onPressed: () async {
                await handlePayment("4.99");
                final pointsNotifier = ref.read(pointsProvider.notifier);
                pointsNotifier.addPoints(100000);
                updateUserPoints(100000);
              },
            ),
            OptionCard(
              points: "250,000",
              price: "9.99",
              onPressed: () async {
                await handlePayment("9.99");
                final pointsNotifier = ref.read(pointsProvider.notifier);
                pointsNotifier.addPoints(250000);
                updateUserPoints(250000);
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
                updateUserPoints(800000);
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
                updateUserPoints(2000000);
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
                updateUserPoints(5000000);
              },
              //  => StripeService.makePayment(context, "99.99"),
            ),
          ],
        ),
      ),
    );
  }
}
