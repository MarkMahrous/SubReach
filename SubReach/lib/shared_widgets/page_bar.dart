import 'package:flutter/material.dart';
import 'package:subreach/theme.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class PageBar extends StatelessWidget implements PreferredSizeWidget {
  const PageBar({super.key, required this.title, required this.sidemenu});

  final String title;
  final bool sidemenu;

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

    return AppBar(
      backgroundColor: AppColor.primary,
      leading: sidemenu
          ? IconButton(
              icon: const Icon(Icons.menu, color: AppColor.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColor.white,
        ),
      ),
      centerTitle: true,
      actions: [
        FutureBuilder<int>(
          future: email != null ? fetchUserPoints() : Future.value(0),
          builder: (context, snapshot) {
            final points = snapshot.data ?? 0;
            return Row(
              children: [
                Text(
                  points.toString(),
                  style: const TextStyle(
                    color: AppColor.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(
                  Icons.monetization_on_outlined,
                  color: AppColor.white,
                  size: 20,
                ),
                const SizedBox(width: 10),
              ],
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
