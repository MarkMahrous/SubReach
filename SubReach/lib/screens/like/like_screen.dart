import 'dart:async';
import 'dart:convert';
import 'package:subreach/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/youtube/v3.dart' as youtube;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:subreach/shared_widgets/app_button.dart';

class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key, required this.videoUrls});

  final List<String> videoUrls;

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  late YoutubePlayerController _controller;
  youtube.YouTubeApi? _youtubeApi;
  bool _isAutoPlayEnabled = false;
  bool _isInitializing = true;
  bool _isGettingpoints = false;
  bool _isTimerRunning = false; // Track if the timer is running
  int _remainingTime = 15; // Remaining time for the countdown
  Timer? _timer;
  GoogleSignInAuthentication? auth;

  List<Map<String, String>> fetchedLikedCampaigns = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeYoutubeApi();
    _loadTimerState();
  }

  Future<void> _loadTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTime = prefs.getInt('remainingTime');
    if (savedTime != null && savedTime > 0) {
      setState(() {
        _remainingTime = savedTime;
        _isTimerRunning = true;
      });
      _startTimer();
    }
  }

  Future<void> _saveTimerState(int time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('remainingTime', time);
  }

  void _startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
          _saveTimerState(_remainingTime);
        } else {
          _timer?.cancel();
          _isTimerRunning = false;
          _saveTimerState(0); // Clear saved timer state
          _playNextVideo();
        }
      });
    });
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

  Future<List<dynamic>> fetchUserViewedCampaigns() async {
    final id = await getUserId();
    print('User ID: $id');
    if (id == null) {
      print('User ID not found');
      return [];
    }
    final url = Uri.parse('http://192.168.0.101:3000/api/users/create?id=$id');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the response body
        final data = jsonDecode(response.body);
        print('viewedCampaigns');
        print(data['viewedCampaigns']);
        return data['viewedCampaigns'] ?? [];
      } else {
        print(
            'Failed to fetch user viewedCampaigns. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching user viewedCampaigns: $e');
      return [];
    }
  }

  Future<List<Map<String, String>>> fetchLikedCampaigns() async {
    final userId = await getUserId(); // Fetch the user ID
    final viewedCampaigns = await fetchUserViewedCampaigns();
    final url = Uri.parse(
        'http://192.168.0.101:3000/api/campaigns/campaigns?type=Like');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Extract _id, ownerId, and video while filtering out user's own campaigns
        final campaigns = data
            .map((campaign) => {
                  'campaignId': campaign['_id'] as String,
                  'ownerId': campaign['owner'] as String,
                  'video': campaign['video'] as String,
                })
            .where(
              (campaign) =>
                  campaign['ownerId'] != userId &&
                  !viewedCampaigns.contains(campaign['campaignId']),
            ) // Exclude user's own campaigns
            .toList();
        print('campaigns');
        print(campaigns);

        return campaigns;
      } else {
        print('Failed to fetch. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching: $e');
      return [];
    }
  }

  void _initializeYoutubeController(String videoId) {
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
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

    try {
      fetchedLikedCampaigns = await fetchLikedCampaigns();
      if (fetchedLikedCampaigns.isNotEmpty) {
        _initializeYoutubeController(fetchedLikedCampaigns[0]['video']!);
      }
    } catch (e) {
      print("Error initializing campaigns: $e");
    } finally {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  void _playNextVideo() {
    if (_currentIndex < fetchedLikedCampaigns.length - 1) {
      setState(() {
        _currentIndex++;
        _controller.load(fetchedLikedCampaigns[_currentIndex]['video']!);
        _isTimerRunning = false; // Stop timer for the next video
        _saveTimerState(0); // Clear timer state
      });
    }
  }

  Future<void> _likeVideo() async {
    setState(() {
      _isGettingpoints = true;
    });
    if (_youtubeApi == null) {
      print("YouTube API is not initialized yet.");
      return;
    }

    try {
      final videoId = fetchedLikedCampaigns[_currentIndex]['video'];
      if (videoId != null) {
        await _youtubeApi!.videos.rate(videoId, "like");
        print("Video liked successfully.");

        final userId = await getUserId();
        await http.patch(
          Uri.parse('http://192.168.0.101:3000/api/users/create?id=$userId'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'points': 240,
            'viewedCampaign': fetchedLikedCampaigns[_currentIndex]
                ['campaignId'],
          }),
        );

        // Start the timer after liking the video
        setState(() {
          _isGettingpoints = false;
          _isTimerRunning = true;
          _remainingTime = 15; // Reset timer to 15 seconds
          fetchedLikedCampaigns.removeAt(_currentIndex);
        });
        _startTimer();
      }
    } catch (e) {
      print("Error liking video or sending request: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel(); // Cancel timer when screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _isInitializing
            ? Center(child: CircularProgressIndicator())
            : fetchedLikedCampaigns.isEmpty
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    color: AppColor.white,
                    width: double.infinity,
                    height: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (_isTimerRunning)
                            Container(
                              color: AppColor.white,
                              height: 200,
                              child: Center(
                                child: Text(
                                  '$_remainingTime',
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          else
                            YoutubePlayer(
                              controller: _controller,
                              showVideoProgressIndicator: true,
                            ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppButton(
                                action: _isTimerRunning ? null : _playNextVideo,
                                text: "Next Video",
                              ),
                              const SizedBox(width: 10),
                              AppButton(
                                action: (_youtubeApi == null ||
                                        _isInitializing ||
                                        _isTimerRunning)
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
                                              _initializeYoutubeController(
                                                  fetchedLikedCampaigns[
                                                      _currentIndex]['video']!);
                                            });
                                          },
                                          activeColor: AppColor.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "Like to YouTube videos.",
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
                  ),
        // Loader overlay
        if (_isGettingpoints)
          Positioned.fill(
            child: Stack(
              children: [
                ModalBarrier(
                  dismissible: false,
                  color:
                      const Color.fromARGB(24, 158, 158, 158).withOpacity(0.9),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      height: 80,
                      color: AppColor.white,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            CircularProgressIndicator(),
                            const SizedBox(width: 16),
                            const Text(
                              "Adding points",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
