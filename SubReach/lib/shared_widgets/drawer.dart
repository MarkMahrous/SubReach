import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:subreach/screens/buy_points/buy_points.dart';
import 'package:subreach/theme.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.onSelectItem});

  final Function onSelectItem;

  String? getCurrentUserEmail() {
    return FirebaseAuth.instance.currentUser?.email;
  }

  String? getUserEmail() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.email; // Returns null if no user is signed in
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

  Future<int> fetchUserPoints() async {
    final id = await getUserId();
    print('User ID: $id');
    if (id == null) {
      print('User ID not found');
      return 0;
    }
    final url = Uri.parse('http://192.168.0.101:3000/api/users/create?id=$id');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the response body
        final data = jsonDecode(response.body);
        print(data['points']);
        return data['points'] ?? 0; // Default to 0 if 'points' is not present
      } else {
        print(
            'Failed to fetch user points. Status code: ${response.statusCode}');
        return 0; // Return 0 or handle error as needed
      }
    } catch (e) {
      print('Error fetching user points: $e');
      return 0; // Return 0 or handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = getCurrentUserEmail();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder<int>(
            future: email != null ? fetchUserPoints() : Future.value(0),
            builder: (context, snapshot) {
              final points = snapshot.data ?? 0;

              return DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple.shade700,
                      Colors.purple.shade300,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/appicon.png'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      email ?? 'No email available',
                      style: const TextStyle(
                        color: AppColor.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Points: $points',
                      style: const TextStyle(
                        color: AppColor.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.attach_money_rounded, color: AppColor.black),
            title: const Text('Buy Points'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const BuyPoints(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.subscriptions, color: AppColor.black),
            title: const Text('Subscribe'),
            onTap: () {
              onSelectItem(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.thumb_up, color: AppColor.black),
            title: const Text('Like'),
            onTap: () {
              onSelectItem(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.remove_red_eye, color: AppColor.black),
            title: const Text('View'),
            onTap: () {
              onSelectItem(2);
            },
          ),
          ListTile(
            leading: const Icon(Icons.campaign, color: AppColor.black),
            title: const Text('Campaigns'),
            onTap: () {
              onSelectItem(3);
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip, color: AppColor.black),
            title: const Text('Privacy Policy'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: AppColor.black),
            title: const Text('Exit'),
            onTap: () {
              SystemNavigator.pop();
            },
          ),
          //logout
          ListTile(
              leading: const Icon(Icons.logout, color: AppColor.black),
              title: const Text('Logout'),
              onTap: () async {
                try {
                  await FirebaseAuth.instance
                      .signOut(); // Sign out from Firebase
                  await GoogleSignIn().signOut(); // Sign out from GoogleSignIn
                  // Use a delay to ensure the SnackBar is shown before navigating
                  Future.delayed(const Duration(milliseconds: 500), () {
                    // Navigate to the login screen if necessary
                    Navigator.of(context).pushReplacementNamed('/auth-screen');
                  });
                } catch (e) {
                  // Show an error SnackBar if something goes wrong

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error signing out: $e')),
                  );
                }
              }),
        ],
      ),
    );
  }
}
