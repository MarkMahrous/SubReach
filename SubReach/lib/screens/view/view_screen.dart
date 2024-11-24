import 'dart:async';
import 'package:flutter/material.dart';
import 'package:subreach/shared_widgets/app_button.dart';
import 'package:subreach/theme.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({
    super.key,
    required this.videoUrls,
  });

  final List<String> videoUrls;

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  late YoutubePlayerController _controller;
  int _timer = 60;
  int _coins = 1080;
  int _currentIndex = 0;
  bool _autoPlay = true;
  Timer? _countdownTimer;
  Duration _lastPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    // Initialize YouTube Player
    _controller = YoutubePlayerController(
      initialVideoId:
          YoutubePlayer.convertUrlToId(widget.videoUrls[_currentIndex])!,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    // Start the timer countdown when the video starts playing
    _controller.addListener(_videoListener);
  }

  void _videoListener() {
    if (_controller.value.isPlaying) {
      _startTimer();
      // Check for seeking and prevent it
      if (_controller.value.position >
          _lastPosition + const Duration(seconds: 2)) {
        _controller.seekTo(_lastPosition); // Reset to the last valid position
      }
      _lastPosition = _controller.value.position;
    } else {
      _stopTimer();
    }
  }

  void _startTimer() {
    if (_countdownTimer == null || !_countdownTimer!.isActive) {
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_timer > 0) {
            _timer--;
          } else {
            _stopTimer();
            _controller.pause();
          }
        });
      });
    }
  }

  void _stopTimer() {
    _countdownTimer?.cancel();
  }

  void _playNextVideo() {
    _stopTimer();
    if (_currentIndex < widget.videoUrls.length - 1) {
      setState(() {
        _currentIndex++;
        _timer = 60; // Reset the timer for the next video
        _lastPosition = Duration.zero; // Reset position tracking
        _controller.load(
            YoutubePlayer.convertUrlToId(widget.videoUrls[_currentIndex])!);
      });
    }
  }

  @override
  void dispose() {
    _stopTimer();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColor.white,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Auto Play",
                      style: TextStyle(color: Colors.black),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        value: _autoPlay,
                        onChanged: (value) {
                          setState(() {
                            _autoPlay = value;
                          });
                        },
                        activeColor: const Color.fromARGB(255, 255, 0, 0),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _infoDisplay(Icons.timer, _timer.toString()),
                    const SizedBox(width: 20),
                    _infoDisplay(Icons.monetization_on, _coins.toString()),
                  ],
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      action: _playNextVideo,
                      text: "SEE NEXT",
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoDisplay(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.black),
        const SizedBox(width: 5),
        Text(
          value,
          style: TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}
