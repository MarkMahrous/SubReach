import 'package:flutter/material.dart';

class LikeCampaign extends StatefulWidget {
  const LikeCampaign({super.key, required this.url});

  final String url;

  @override
  State<LikeCampaign> createState() => _LikeCampaignState();
}

class _LikeCampaignState extends State<LikeCampaign> {
  @override
  Widget build(BuildContext context) {
    return const Text("Like Campaign");
  }
}
