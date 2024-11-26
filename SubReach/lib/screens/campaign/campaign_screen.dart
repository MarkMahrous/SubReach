import 'package:flutter/material.dart';
import 'package:subreach/screens/campaign/widgets/add_campaign_button.dart';
import 'package:subreach/screens/campaign/widgets/like_campaign.dart';
import 'package:subreach/screens/campaign/widgets/my_campaigns.dart';
import 'package:subreach/screens/campaign/widgets/subscribe_campaign.dart';
import 'package:subreach/screens/campaign/widgets/view_campaign.dart';
import 'package:subreach/theme.dart';

class CampaignScreen extends StatefulWidget {
  const CampaignScreen({super.key});

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  String activeBody = "MyCampaigns";
  Widget activeWidget = MyCampaigns();
  String url = "";
  final TextEditingController _urlController = TextEditingController();

  void showPopUp(String body) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add your video'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  hintText: 'Enter your YouTube video link here',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'How to get link: open your video on YT -> share button -> copy link',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(
                  () {
                    url = _urlController.text;
                    if (body == "View") {
                      activeWidget = ViewCampaign(
                          url: url, onBackToMyCampaigns: switchToMyCampaigns);
                    } else if (body == "Subscribe") {
                      activeWidget = SubscribeCampaign(
                          url: url, onBackToMyCampaigns: switchToMyCampaigns);
                    } else {
                      activeWidget = LikeCampaign(
                          url: url, onBackToMyCampaigns: switchToMyCampaigns);
                    }
                    activeBody = body;
                  },
                );
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void switchToMyCampaigns() {
    setState(() {
      activeWidget = MyCampaigns();
      activeBody = "MyCampaigns";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        color: AppColor.white,
        child: activeWidget,
      ),
      floatingActionButton: activeBody == "MyCampaigns"
          ? AddCampaignButton(
              onPressed: showPopUp,
            )
          : null,
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
}
