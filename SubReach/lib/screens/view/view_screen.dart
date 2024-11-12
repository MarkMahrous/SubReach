import 'package:flutter/material.dart';
import 'package:subreach/shared_widgets/app_button.dart';
import 'package:subreach/theme.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({super.key, required this.videoUrls});

  final List<String> videoUrls;

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  late YoutubePlayerController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId:
          YoutubePlayer.convertUrlToId(widget.videoUrls[_currentIndex])!,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  void _playNextVideo() {
    if (_currentIndex < widget.videoUrls.length - 1) {
      setState(() {
        _currentIndex++;
        _controller.load(
            YoutubePlayer.convertUrlToId(widget.videoUrls[_currentIndex])!);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.white,
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
            ),
            const SizedBox(height: 10),
            AppButton(
              action: _playNextVideo,
              text: "Next Video",
            ),
          ],
        ),
      ),
    );
  }
}
