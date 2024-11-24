import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:subreach/screens/campaign/campaign_screen.dart';
import 'package:subreach/screens/like/like_screen.dart';
import 'package:subreach/screens/points/points_screen.dart';
import 'package:subreach/screens/subscribe/subscribe_screen.dart';
import 'package:subreach/screens/view/view_screen.dart';
import 'package:subreach/shared_widgets/page_bar.dart';
import 'package:subreach/shared_widgets/drawer.dart';
import 'package:subreach/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  List<String> videoUrls = [];

  @override
  void initState() {
    super.initState();
    fetchVideoUrls(); // Fetch video URLs when the screen initializes
  }

  Future<void> fetchVideoUrls() async {
    final url = Uri.parse('http://192.168.232.231:3000/api/videos/uploaded');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          // Decode the response and update the video URLs
          videoUrls = List<String>.from(json.decode(response.body));
        });
      } else {
        print(
            'Failed to fetch video URLs. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching video URLs: $e');
    }
  }

  void _selectScreen(index) {
    setState(() {
      currentIndex = index;
    });
  }

  void _closeDrawer(index) {
    setState(() {
      currentIndex = index;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    Widget? activeScreen;

    switch (currentIndex) {
      case 0:
        activeScreen = SubscribeScreen(videoUrls: videoUrls);
        break;
      case 1:
        activeScreen = LikeScreen(videoUrls: videoUrls);
        break;
      case 2:
        activeScreen = ViewScreen(videoUrls: videoUrls);
        break;
      case 3:
        activeScreen = const CampaignScreen();
        break;
      case 4:
        activeScreen = const PointsScreen();
        break;
    }

    return Scaffold(
      appBar: const PageBar(
        title: 'SubReach',
        sidemenu: true,
      ),
      drawer: AppDrawer(
        onSelectItem: _closeDrawer,
      ),
      body: videoUrls.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : activeScreen,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectScreen,
        currentIndex: currentIndex,
        selectedItemColor: AppColor.primary,
        unselectedItemColor: AppColor.grey,
        backgroundColor: AppColor.white,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        iconSize: 24,
        selectedIconTheme: const IconThemeData(
          size: 26, // Larger size for selected icon
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions), // Icon for "Subscribe"
            label: 'Subscribe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thumb_up), // Icon for "Like"
            label: 'Like',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.remove_red_eye), // Icon for "View"
            label: 'View',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign), // Icon for "Campaign"
            label: 'Campaign',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on_outlined), // Icon for "Points"
            label: 'Points',
          ),
        ],
        selectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
