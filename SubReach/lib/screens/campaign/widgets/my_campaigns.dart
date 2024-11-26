import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:subreach/theme.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class MyCampaigns extends StatefulWidget {
  const MyCampaigns({super.key});

  @override
  State<MyCampaigns> createState() => _MyCampaignsState();
}

class _MyCampaignsState extends State<MyCampaigns> {
  late Future<List<Map<String, Object>>?> campaignsFuture;

  @override
  void initState() {
    super.initState();
    campaignsFuture = getUserCreatedCampaigns();
  }

  String? getUserEmail() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }

  Future<List<Map<String, Object>>?> getUserCreatedCampaigns() async {
    final userEmail = getUserEmail();
    final url = Uri.parse(
        'http://192.168.0.101:3000/api/users/create?email=$userEmail');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data[0]['createdCampaigns'] as List)
            .map((campaign) => Map<String, Object>.from(campaign))
            .toList();
      } else {
        print('Failed to fetch campaigns. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching campaigns: $e');
      return null;
    }
  }

  String getThumbnailUrl(String videoId) {
    return "https://img.youtube.com/vi/$videoId/0.jpg"; // URL for YouTube video thumbnail
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColor.white,
        child: FutureBuilder<List<Map<String, Object>>?>(
          future: campaignsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error loading campaigns. Please try again later.",
                  style: const TextStyle(fontSize: 18, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return noCampaigns();
            } else {
              final myCampaigns = snapshot.data!;
              return ListView.builder(
                itemCount: myCampaigns.length,
                itemBuilder: (context, index) {
                  final campaign = myCampaigns[index];
                  final thumbnailUrl =
                      getThumbnailUrl(campaign["video"] as String);
                  return Card(
                    color: AppColor.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            thumbnailUrl,
                            width: 100,
                            height: 65,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Video Id: ${campaign["video"]}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      "0/${campaign["amount"]} ${campaign["type"]}s",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    if (campaign["type"] == "View")
                                      Row(
                                        children: [
                                          const Icon(Icons.timer,
                                              size: 18, color: Colors.grey),
                                          const SizedBox(width: 5),
                                          Text(
                                            "${campaign["time"]}s",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget noCampaigns() {
    return const Center(
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
