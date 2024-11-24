import 'package:flutter/material.dart';
import 'package:subreach/theme.dart';

class AppButton extends StatelessWidget {
  const AppButton({super.key, required this.action, required this.text});

  final void Function()? action;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: action,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primary,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColor.white,
        ),
      ),
    );
  }
}
