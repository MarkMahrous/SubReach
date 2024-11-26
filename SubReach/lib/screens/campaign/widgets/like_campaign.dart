import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subreach/providers/points_provider.dart';
import 'package:subreach/theme.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LikeCampaign extends ConsumerStatefulWidget {
  final String url;
  final VoidCallback onBackToMyCampaigns;

  const LikeCampaign(
      {super.key, required this.url, required this.onBackToMyCampaigns});

  @override
  ConsumerState<LikeCampaign> createState() => _LikeCampaignState();
}

class _LikeCampaignState extends ConsumerState<LikeCampaign> {
  late YoutubePlayerController _controller;
  final TextEditingController likesController = TextEditingController();

  String likesError = 'Invalid Number!';
  int totalPoints = 0;
  String? videoId = '';
  int? userPoints;

  @override
  void initState() {
    super.initState();
    // Extract YouTube video ID from the URL
    videoId = YoutubePlayer.convertUrlToId(widget.url);
    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    likesController.dispose();
    super.dispose();
  }

  String? getUserEmail() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }

  Future<String?> getUserId() async {
    final userEmail = getUserEmail();
    final url = Uri.parse(
        'http://192.168.0.101:3000/api/users/create?email=$userEmail');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('userId');
        print(data[0]['_id']);
        print(data[0]['points']);
        userPoints = data[0]['points'];
        return data[0]['_id'];
      } else {
        print('Failed to fetch user ID. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching user ID: $e');
      return null;
    }
  }

  void validate() {
    setState(() {
      // Validate "Number of Likes"
      final likes = int.tryParse(likesController.text);
      if (likes == null || likes < 10 || likes > 5000) {
        likesError = 'Invalid Number!';
        totalPoints = 0;
      } else {
        likesError = '';
      }

      // If no errors, proceed with campaign creation
      if (likesError.isEmpty) {
        totalPoints = likes! * 400;
      }
    });
  }

  void submit() async {
    validate();
    getUserEmail();
    await getUserId();
    if (userPoints == null) {
      return;
    }
    if (!likesError.isEmpty || userPoints! < totalPoints) {
      return;
    }
    final response = await createCampaign();
    if (response.isNotEmpty) {
      print('Campaign created successfully!');
      final pointsNotifier = ref.read(pointsProvider.notifier);
      pointsNotifier.addPoints(totalPoints * -1);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Campaign created successfully!'),
        ),
      );
      widget.onBackToMyCampaigns();
    } else {
      print('Failed to create campaign.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create campaign.'),
        ),
      );
    }
  }

  Future<Map<String, dynamic>> createCampaign() async {
    final userId = await getUserId();
    try {
      final likes = int.tryParse(likesController.text);
      final response = await http.post(
        Uri.parse('http://192.168.0.101:3000/api/campaigns/campaigns'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": "View Campaign $userId $videoId",
          "budget": totalPoints,
          "owner": userId,
          "type": "Like",
          "video": videoId,
          "time": 0,
          "amount": likes
        }),
      );

      if (response.statusCode == 201) {
        print('Campaign created successfully!');
        return jsonDecode(response.body);
      } else {
        print('Failed to create campaign: ${response.body}');
        return {};
      }
    } catch (error) {
      print("Error during campaign creation: $error");
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // YouTube Player
        YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          onReady: () {
            debugPrint('YouTube Player is ready.');
          },
        ),
        const SizedBox(height: 20),

        // "Number of Likes" Input
        const Text(
          'Number of Likes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Row(
          children: [
            Align(
              alignment: Alignment.centerLeft, // Align to the left
              child: SizedBox(
                width: 150,
                child: TextField(
                  onChanged: (_) => validate(),
                  controller: likesController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    errorText: likesError.isNotEmpty ? likesError : null,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              totalPoints == 0 ? '' : '= $totalPoints Points',
              style: TextStyle(
                fontSize: 22,
                color: AppColor.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        const Text("(min: 10, max: 5000)"),
        const SizedBox(height: 30),

        // Note
        const Text(
          '*NOTE',
          style: TextStyle(
            color: AppColor.primary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Your coins will be reduced after you create this campaign.\nThis action cannot be undone.',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 20),

        // "Create Campaign" Button
        ElevatedButton(
          onPressed: submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          child: const Text(
            'Create Campaign',
            style: TextStyle(
              fontSize: 18,
              color: AppColor.white,
            ),
          ),
        ),
      ],
    );
  }
}
