import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subreach/providers/points_provider.dart';
import 'package:subreach/theme.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ViewCampaign extends ConsumerStatefulWidget {
  final String url;
  final VoidCallback onBackToMyCampaigns;

  const ViewCampaign(
      {super.key, required this.url, required this.onBackToMyCampaigns});

  @override
  ConsumerState<ViewCampaign> createState() => _ViewCampaignState();
}

class _ViewCampaignState extends ConsumerState<ViewCampaign> {
  late YoutubePlayerController _controller;
  final TextEditingController _viewsController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  String viewsError = 'Invalid Number!';
  String timeError = 'Invalid Time!';
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
      // Validate "Number of Views"
      final views = int.tryParse(_viewsController.text);
      if (views == null || views < 10 || views > 5000) {
        viewsError = 'Invalid Number!';
        totalPoints = 0;
      } else {
        viewsError = '';
      }

      // Validate "Time Required"
      final validTimes = [45, 60, 90, 150, 300, 600];
      final time = int.tryParse(_timeController.text);
      if (time == null || !validTimes.contains(time)) {
        timeError = 'Invalid Time!';
        totalPoints = 0;
      } else {
        timeError = '';
      }

      // If no errors, proceed with campaign creation
      if (viewsError.isEmpty && timeError.isEmpty) {
        totalPoints = views! * time! * 3;
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
    if (!viewsError.isEmpty ||
        !timeError.isEmpty ||
        userPoints! < totalPoints) {
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
      final views = int.tryParse(_viewsController.text);
      final time = int.tryParse(_timeController.text);
      final response = await http.post(
        Uri.parse('http://192.168.0.101:3000/api/campaigns/campaigns'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": "View Campaign $userId $videoId",
          "budget": totalPoints,
          "owner": userId,
          "type": "View",
          "video": videoId,
          "time": time,
          "amount": views
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
  void dispose() {
    _controller.dispose();
    _viewsController.dispose();
    _timeController.dispose();
    super.dispose();
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

        // "Number of Views" Input
        const Text(
          'Number of Views',
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
                  controller: _viewsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    errorText: viewsError.isNotEmpty ? viewsError : null,
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
        const SizedBox(height: 10),

        // "Time Required" Input
        const Text(
          'Time Required (Seconds)',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft, // Align to the left
          child: SizedBox(
            width: 150,
            child: TextField(
              onChanged: (_) => validate(),
              controller: _timeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                errorText: timeError.isNotEmpty ? timeError : null,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        const Text("Values Accepted: 45, 60, 90, 150, 300, 600"),
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
