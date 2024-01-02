import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_journal/Functions/user_functions.dart';

class ProfileButtonsAlt extends StatelessWidget {
  ProfileButtonsAlt({
    super.key,
    required this.profileUser,
  });

  final String profileUser;
  final UserFunctions userFunctions = UserFunctions();
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<bool> isFollowed() async {
    final currentUser = userFunctions.getCurrentUserEmail();
    Map<String, dynamic>? currentUserInfo = await userFunctions.getInfo(currentUser);
    List<dynamic> currentUserFollowing = currentUserInfo?['following'];
    if (currentUserFollowing.contains(profileUser)) {
      return true;
    }
    return false;
  }

  void follow() async {
    final currentUser = userFunctions.getCurrentUserEmail();
    Map<String, dynamic>? currentUserInfo = await userFunctions.getInfo(currentUser);
    Map<String, dynamic>? profileUserInfo = await userFunctions.getInfo(profileUser);

    List<dynamic> currentUserFollowing = currentUserInfo?['following'];
    List<dynamic> profileUserFollowers = profileUserInfo?['followers'];

    currentUserFollowing.add(profileUser);
    profileUserFollowers.add(currentUser);

    await db.collection('users').doc(currentUser).update({'following': currentUserFollowing});
    await db.collection('users').doc(profileUser).update({'followers': profileUserFollowers});
  }

  void unFollow() async {
    final currentUser = userFunctions.getCurrentUserEmail();
    Map<String, dynamic>? currentUserInfo = await userFunctions.getInfo(currentUser);
    Map<String, dynamic>? profileUserInfo = await userFunctions.getInfo(profileUser);

    List<dynamic> currentUserFollowing = currentUserInfo?['following'];
    List<dynamic> profileUserFollowers = profileUserInfo?['following'];

    currentUserFollowing.remove(profileUser);
    profileUserFollowers.remove(currentUser);

    await db.collection('users').doc(currentUser).update({'following': currentUserFollowing});
    await db.collection('users').doc(profileUser).update({'followers': profileUserFollowers});
  }

  @override
  Widget build(BuildContext context) {
    // Follow Button
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FutureBuilder(
          future: isFollowed(),
          builder: (context, snapshot) {
            // Check if the Future is still running
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // Check if there's an error in the Future
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            // If the Future has completed successfully, use the data
            bool? isFollowed = snapshot.data;
            if (isFollowed == false) {
              return FloatingActionButton.extended(
                onPressed: () {
                  follow();
                  Navigator.pop(context);
                },
                heroTag: 'follow',
                elevation: 0,
                label: const Text("Follow"),
                icon: const Icon(Icons.person_add_alt_1),
                backgroundColor: Colors.purple[100],
              );
            } else {
              return FloatingActionButton.extended(
                onPressed: () {
                  unFollow();
                  Navigator.pop(context);
                },
                heroTag: 'unfollow',
                elevation: 0,
                label: const Text("unfollow"),
                icon: const Icon(Icons.person_remove_alt_1),
                backgroundColor: Colors.amber[100],
              );
            }
          },
        ),
        const SizedBox(width: 20.0),
        const LogoutButton()
      ],
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.pop(context);
      },
      heroTag: 'logout',
      elevation: 0,
      backgroundColor: Colors.pink[100],
      label: const Text("Close"),
      icon: const Icon(Icons.close_rounded),
    );
  }
}
