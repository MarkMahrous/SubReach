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

  void showPopUp(String body) {
    activeBody = body;

    // setState(() {
    //   if (body == "MyCampaigns") {
    //     activeWidget = MyCampaigns();
    //   } else if (body == "View") {
    //     activeWidget = ViewCampaign(url: url);
    //   } else if (body == "Like") {
    //     activeWidget = LikeCampaign(url: url);
    //   } else {
    //     activeWidget = SubscribeCampaign(url: url);
    //   }
    // });
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
}
