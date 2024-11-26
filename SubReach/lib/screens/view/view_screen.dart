import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/youtube/v3.dart' as youtube;
import 'package:googleapis_auth/auth_io.dart';
import 'package:subreach/providers/points_provider.dart';
import 'package:subreach/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:subreach/shared_widgets/app_button.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ViewScreen extends ConsumerStatefulWidget {
  const ViewScreen({
    super.key,
    required this.videoUrls,
  });

  final List<String> videoUrls;

  @override
  ConsumerState<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends ConsumerState<ViewScreen> {
  late YoutubePlayerController _controller;
  youtube.YouTubeApi? _youtubeApi;
  bool _isInitializing = true;
  bool isGettingPoints = true;
  int _timer = 0;
  int _coins = 0;
  int _currentIndex = 0;
  bool _autoPlay = true;
  Timer? _countdownTimer;
  Duration _lastPosition = Duration.zero;
  GoogleSignInAuthentication? auth;
  List<Map<String, Object>> fetchedViewCampaigns = [];

  @override
  void initState() {
    super.initState();
    _initializeYoutubeApi();
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
            // _controller.pause();
            if (isGettingPoints) {
              isGettingPoints = false;
              _getPoints();
              final pointsNotifier = ref.read(pointsProvider.notifier);
              pointsNotifier.addPoints(240);
            }
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
    if (_currentIndex < fetchedViewCampaigns.length - 1) {
      setState(() {
        _currentIndex++;
        _controller
            .load(fetchedViewCampaigns[_currentIndex]['video'] as String);
        _timer = fetchedViewCampaigns[_currentIndex]['time'] as int;
        _coins = _timer * 2;
        isGettingPoints = true;
        _lastPosition = Duration.zero; // Reset position tracking
      });
    }
  }

  void _getPoints() async {
    final userId = await getUserId();
    await http.patch(
      Uri.parse('http://192.168.0.101:3000/api/users/create?id=$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'points': _coins,
        'viewedCampaign': fetchedViewCampaigns[_currentIndex]['campaignId'],
      }),
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

  Future<List<Map<String, Object>>> fetchViewCampaigns() async {
    final userId = await getUserId(); // Fetch the user ID
    final viewedCampaigns = await fetchUserViewedCampaigns();
    final url = Uri.parse(
        'http://192.168.0.101:3000/api/campaigns/campaigns?type=View');

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
                  'time': campaign['time'] as int,
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
        autoPlay: true,
        mute: false,
      ),
    );
    _controller.addListener(_videoListener);
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
      fetchedViewCampaigns = await fetchViewCampaigns();
      if (fetchedViewCampaigns.isNotEmpty) {
        _initializeYoutubeController(
            fetchedViewCampaigns[0]['video'] as String);
        _timer = fetchedViewCampaigns[0]['time'] as int;
        _coins = _timer * 2;
      }
    } catch (e) {
      print("Error initializing campaigns: $e");
    } finally {
      setState(() {
        _isInitializing = false;
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
      body: _isInitializing
          ? Center(child: CircularProgressIndicator())
          : fetchedViewCampaigns.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
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
                                  activeColor:
                                      const Color.fromARGB(255, 255, 0, 0),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _infoDisplay(Icons.timer, _timer.toString()),
                              const SizedBox(width: 20),
                              _infoDisplay(
                                  Icons.monetization_on, _coins.toString()),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
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
