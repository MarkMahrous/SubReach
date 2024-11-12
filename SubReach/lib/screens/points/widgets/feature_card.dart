import 'package:flutter/material.dart';
import 'package:subreach/shared_widgets/app_button.dart';
import 'package:subreach/theme.dart';

class FeatureCard extends StatelessWidget {
  const FeatureCard({
    super.key,
    required this.action,
    required this.text,
    required this.image,
  });

  final void Function() action;
  final String text;
  final String image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: SizedBox(
        height: 165,
        child: Card(
          color: AppColor.white,
          elevation: 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Transform.scale(
                  scale: 0.7,
                  child: Image.asset(image),
                ),
              ),
              AppButton(
                action: action,
                text: text,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
