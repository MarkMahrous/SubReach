import 'package:flutter/material.dart';
import 'package:subreach/screens/campaign/widgets/add_campaign_button.dart';
import 'package:subreach/theme.dart';

class MyCampaigns extends StatefulWidget {
  const MyCampaigns({super.key});

  @override
  State<MyCampaigns> createState() => _MyCampaignsState();
}

class _MyCampaignsState extends State<MyCampaigns> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        color: AppColor.white,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.home_outlined,
                size: 100,
              ),
              Text(
                "No Campaign",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              Text(
                "Your campaign appear here, Click add button to create campaign to get subscribers for your channel",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
