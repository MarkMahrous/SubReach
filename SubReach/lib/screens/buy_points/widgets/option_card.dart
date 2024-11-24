import 'package:flutter/material.dart';
import 'package:subreach/theme.dart';

class OptionCard extends StatelessWidget {
  final String points;
  final String price;
  final VoidCallback onPressed;

  const OptionCard({
    super.key,
    required this.points,
    required this.price,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          "$points Points",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("\$$price"),
        trailing: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, // Replace with desired color
          ),
          child: const Text("Buy"),
        ),
      ),
    );
  }
}
