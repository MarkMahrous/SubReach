import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// StateNotifier to manage user points
class PointsNotifier extends StateNotifier<int> {
  PointsNotifier() : super(0);

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

  // Fetch user points from the server
  Future<int> fetchUserPoints() async {
    final id = await getUserId(); // Replace with your logic to get user ID
    if (id == null) return 0;

    final url = Uri.parse('http://192.168.0.101:3000/api/users/create?id=$id');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        state = data['points'] ?? 0; // Update the state
        return data['points'] ?? 0;
      } else {
        print(
            'Failed to fetch user points. Status code: ${response.statusCode}');
        return 0;
      }
    } catch (e) {
      print('Error fetching user points: $e');
      return 0;
    }
  }

  // Increment points locally after an action
  void addPoints(int points) {
    state += points;
  }
}

// Provider to access PointsNotifier
final pointsProvider = StateNotifierProvider<PointsNotifier, int>((ref) {
  return PointsNotifier();
});
