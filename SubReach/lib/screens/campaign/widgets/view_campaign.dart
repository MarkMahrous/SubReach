import 'package:flutter/material.dart';
import 'package:subreach/theme.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ViewCampaign extends StatefulWidget {
  final String url;

  const ViewCampaign({super.key, required this.url});

  @override
  State<ViewCampaign> createState() => _ViewCampaignState();
}

class _ViewCampaignState extends State<ViewCampaign> {
  late YoutubePlayerController _controller;
  final TextEditingController _viewsController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  String viewsError = 'Invalid Number!';
  String timeError = 'Invalid Time!';
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
    _viewsController.dispose();
    _timeController.dispose();
    super.dispose();
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
