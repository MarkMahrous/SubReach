import 'package:flutter/material.dart';
import 'package:subreach/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subreach/providers/points_provider.dart';

class PageBar extends ConsumerWidget implements PreferredSizeWidget {
  const PageBar({super.key, required this.title, required this.sidemenu});

  final String title;
  final bool sidemenu;

  String? getUserEmail() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.email; // Returns null if no user is signed in
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myPoints = ref.watch(pointsProvider);
    final pointsNotifier = ref.read(pointsProvider.notifier);
    final email = getUserEmail();

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
          future: email != null
              ? pointsNotifier.fetchUserPoints()
              : Future.value(0),
          builder: (context, snapshot) {
            final points = snapshot.data ?? myPoints;
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
