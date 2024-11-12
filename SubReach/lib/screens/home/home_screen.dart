import 'package:flutter/material.dart';
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
        activeScreen = const SubscribeScreen(
          videoUrls: [
            "https://www.youtube.com/watch?v=ioTBIpKCUpM",
            "https://www.youtube.com/watch?v=-g4vvXmE0YI",
            "https://www.youtube.com/watch?v=G28SocqOwOE",
          ],
        );
        break;
      case 1:
        activeScreen = const LikeScreen(
          videoUrls: [
            "https://www.youtube.com/watch?v=ioTBIpKCUpM",
            "https://www.youtube.com/watch?v=-g4vvXmE0YI",
            "https://www.youtube.com/watch?v=G28SocqOwOE",
          ],
        );
        break;
      case 2:
        activeScreen = const ViewScreen(
          videoUrls: [
            "https://www.youtube.com/watch?v=ioTBIpKCUpM",
            "https://www.youtube.com/watch?v=-g4vvXmE0YI",
            "https://www.youtube.com/watch?v=G28SocqOwOE",
          ],
        );
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
      body: activeScreen,
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
