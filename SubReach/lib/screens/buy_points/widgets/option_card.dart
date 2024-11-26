import 'package:flutter/material.dart';
import 'package:subreach/theme.dart';

class OptionCard extends StatelessWidget {
  const OptionCard(
      {super.key,
      required this.points,
      required this.price,
      required this.onPressed});
  final String points;
  final String price;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColor.white,
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    "+$points",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.monetization_on_outlined),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
              ),
              onPressed: onPressed,
              child: Text(
                "$price\$",
                style: const TextStyle(
                  color: AppColor.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
