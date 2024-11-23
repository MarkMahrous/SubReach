import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:subreach/screens/buy_points/buy_points.dart';
import 'package:subreach/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subreach/providers/points_provider.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key, required this.onSelectItem});

  final Function onSelectItem;

  String? getUserEmail() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.email; // Returns null if no user is signed in
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myPoints = ref.watch(pointsProvider);
    final pointsNotifier = ref.read(pointsProvider.notifier);
    final email = getUserEmail();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder<int>(
            future: email != null
                ? pointsNotifier.fetchUserPoints()
                : Future.value(0),
            builder: (context, snapshot) {
              final points = snapshot.data ?? myPoints;

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
