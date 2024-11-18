import 'package:flutter/material.dart';
import 'package:subreach/theme.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SubscribeCampaign extends StatefulWidget {
  final String url;

  const SubscribeCampaign({super.key, required this.url});

  @override
  State<SubscribeCampaign> createState() => _SubscribeCampaignState();
}

class _SubscribeCampaignState extends State<SubscribeCampaign> {
  late YoutubePlayerController _controller;
  final TextEditingController subscribesController = TextEditingController();

  String subscribesError = 'Invalid Number!';
  int totalPoints = 0;

  @override
  void initState() {
    super.initState();
    // Extract YouTube video ID from the URL
    final videoId = YoutubePlayer.convertUrlToId(widget.url);
    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    subscribesController.dispose();
    super.dispose();
  }

  void validate() {
    setState(() {
      // Validate "Number of Subscribers"
      final subscribers = int.tryParse(subscribesController.text);
      if (subscribers == null || subscribers < 10 || subscribers > 5000) {
        subscribesError = 'Invalid Number!';
        totalPoints = 0;
      } else {
        subscribesError = '';
      }

      // If no errors, proceed with campaign creation
      if (subscribesError.isEmpty) {
        totalPoints = subscribers! * 600;
      }
    });
  }

  void submit() {
    // Submit the campaign to the server
    // ...
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

        // "Number of Subscribers" Input
        const Text(
          'Number of Subscribers',
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
                  controller: subscribesController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    errorText:
                        subscribesError.isNotEmpty ? subscribesError : null,
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
