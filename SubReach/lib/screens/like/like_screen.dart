import 'package:flutter/material.dart';
import 'package:subreach/shared_widgets/app_button.dart';
import 'package:subreach/theme.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:googleapis/youtube/v3.dart' as youtube;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key, required this.videoUrls});

  final List<String> videoUrls;

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  late YoutubePlayerController _controller;
  youtube.YouTubeApi? _youtubeApi;
  int _currentIndex = 0;
  bool _isAutoPlayEnabled = false;
  bool _isInitializing = true;
  GoogleSignInAuthentication? auth;

  @override
  void initState() {
    super.initState();
    _initializeYoutubeApi();
    _controller = YoutubePlayerController(
      initialVideoId:
          YoutubePlayer.convertUrlToId(widget.videoUrls[_currentIndex])!,
      flags: YoutubePlayerFlags(
        autoPlay: _isAutoPlayEnabled,
        mute: false,
      ),
    );
  }

  Future<void> _initializeYoutubeApi() async {
    setState(() {
      _isInitializing = true;
    });

    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [youtube.YouTubeApi.youtubeForceSslScope],
    );

    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // Sign-in was canceled by the user.
        setState(() {
          _isInitializing = false;
        });
        print("Google sign-in was canceled.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign-in canceled. Please try again.")),
        );
        return; // Exit the function if sign-in fails.
      }

      auth = await googleUser.authentication;
      if (auth?.accessToken == null) {
        setState(() {
          _isInitializing = false;
        });
        print("Access token retrieval failed.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("Failed to retrieve access token. Please try again.")),
        );
        return;
      }

      final authenticateClient = authenticatedClient(
        http.Client(),
        AccessCredentials(
          AccessToken(
            'Bearer',
            auth?.accessToken ?? '',
            DateTime.now().add(Duration(hours: 1)).toUtc(), // Convert to UTC
          ),
          null, // Leave refresh token as null if unavailable.
          [youtube.YouTubeApi.youtubeForceSslScope],
        ),
      );

      setState(() {
        _youtubeApi = youtube.YouTubeApi(authenticateClient);
        _isInitializing = false;
      });

      print("Google sign-in succeeded, and YouTube API is initialized.");
    } catch (error) {
      setState(() {
        _isInitializing = false;
      });
      print("Error during Google sign-in: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign-in failed. Please try again later.")),
      );
    }
  }

  Future<void> _likeVideo() async {
    if (_youtubeApi == null) {
      print("YouTube API is not initialized yet.");
      return;
    }

    try {
      final videoId =
          YoutubePlayer.convertUrlToId(widget.videoUrls[_currentIndex]);
      if (videoId != null) {
        await _youtubeApi!.videos.rate(videoId, "like");

        print("Video liked successfully.");
      }
    } catch (e) {
      print("Error liking video: $e");
    }
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppButton(
                  action: _playNextVideo,
                  text: "Next Video",
                ),
                const SizedBox(width: 10),
                AppButton(
                  action: (_youtubeApi == null || _isInitializing)
                      ? null
                      : () => _likeVideo(),
                  text: "Like",
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 3,
              color: AppColor.white,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "Auto Play",
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 10),
                        Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: _isAutoPlayEnabled,
                            onChanged: (value) {
                              setState(() {
                                _isAutoPlayEnabled = value;
                                _controller = YoutubePlayerController(
                                  initialVideoId: YoutubePlayer.convertUrlToId(
                                      widget.videoUrls[_currentIndex])!,
                                  flags: YoutubePlayerFlags(
                                    autoPlay: _isAutoPlayEnabled,
                                    mute: false,
                                  ),
                                );
                              });
                            },
                            activeColor: AppColor.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Like to youtube videos.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
