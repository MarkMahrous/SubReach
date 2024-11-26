import 'package:flutter/material.dart';
import 'package:subreach/theme.dart';

class MyCampaigns extends StatefulWidget {
  const MyCampaigns({super.key});

  @override
  State<MyCampaigns> createState() => _MyCampaignsState();
}

class _MyCampaignsState extends State<MyCampaigns> {
  final myCampaigns = [
    {
      "time": 45,
      "amount": 20,
      "type": "View",
      "video": "IpkrifR88PU",
    },
    {
      "time": 45,
      "amount": 10,
      "type": "View",
      "video": "SPS7mxaMgwU",
    },
    {
      "time": 0,
      "amount": 10,
      "type": "Like",
      "video": "SPS7mxaMgwU",
    }
  ];

  String getThumbnailUrl(String videoId) {
    return "https://img.youtube.com/vi/$videoId/0.jpg"; // URL for YouTube video thumbnail
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColor.white,
        child: myCampaigns.isEmpty
            ? noCampaigns()
            : ListView.builder(
                itemCount: myCampaigns.length,
                itemBuilder: (context, index) {
                  final campaign = myCampaigns[index];
                  final thumbnailUrl =
                      getThumbnailUrl(campaign["video"] as String);
                  return Card(
                    color: AppColor.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Image.network(
                            thumbnailUrl,
                            width: 100,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Video Id: ${campaign["video"]}"),
                              Row(
                                children: [
                                  Text(
                                    "0/${campaign["amount"]} ${campaign["type"]}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                      child: Row(
                                    children: [
                                      const Icon(Icons.timer),
                                      Text("${campaign["time"]}s"),
                                    ],
                                  )),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget noCampaigns() {
    return Center(
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
    );
  }
}
