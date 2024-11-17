import 'package:flutter/material.dart';
import 'package:subreach/theme.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CampaignScreen extends StatefulWidget {
  const CampaignScreen({super.key});

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  final TextEditingController _urlController = TextEditingController();
  YoutubePlayerController? _youtubePlayerController;
  bool _isVideoAdded = false;

  void _addVideo() {
    final url = _urlController.text;
    if (url.isNotEmpty) {
      final videoId = YoutubePlayer.convertUrlToId(url);
      if (videoId != null) {
        setState(() {
          _youtubePlayerController = YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(
              autoPlay: true,
              mute: false,
            ),
          );
          _isVideoAdded = true;
        });
      } else {
        // Show an error if the URL is invalid
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid YouTube URL")),
        );
      }
    }
  }

  Future<void> _createCampaign() async {
    const url = 'http://192.168.0.199:3000/api/videos/campaign';
    final email =
        'user@example.com'; // Replace with actual user email if available

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'url': _urlController.text,
        'minus_points': 10,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Campaign created successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to create campaign")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColor.white,
      child: Center(
        child: _isVideoAdded
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  YoutubePlayer(
                    controller: _youtubePlayerController!,
                    showVideoProgressIndicator: true,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _createCampaign,
                    child: const Text('Create Campaign'),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                      hintText: "Enter YouTube video URL",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _addVideo,
                    child: const Text('Add'),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    _youtubePlayerController?.dispose();
    super.dispose();
  }
}
