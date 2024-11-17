import 'package:flutter/material.dart';

class SubscribeCampaign extends StatefulWidget {
  const SubscribeCampaign({super.key, required this.url});

  final String url;

  @override
  State<SubscribeCampaign> createState() => _SubscribeCampaignState();
}

class _SubscribeCampaignState extends State<SubscribeCampaign> {
  @override
  Widget build(BuildContext context) {
    return const Text("Subscribe Campaign");
  }
}
