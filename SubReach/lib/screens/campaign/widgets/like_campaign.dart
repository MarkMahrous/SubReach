import 'package:flutter/material.dart';
import 'package:subreach/theme.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LikeCampaign extends StatefulWidget {
  final String url;

  const LikeCampaign({super.key, required this.url});

  @override
  State<LikeCampaign> createState() => _LikeCampaignState();
}

class _LikeCampaignState extends State<LikeCampaign> {
  late YoutubePlayerController _controller;
  final TextEditingController likesController = TextEditingController();

  String likesError = 'Invalid Number!';
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
    likesController.dispose();
    super.dispose();
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
