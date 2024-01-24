import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_journal/Functions/user_functions.dart';
import 'package:flutter_journal/pages/journal/landing.dart';
import 'package:flutter_journal/pages/journal/profile.dart';

class ViewFollowCard extends StatelessWidget {
  ViewFollowCard({
    super.key,
    required this.name,
    required this.type,
  });
  final String name;
  final String type;

  final UserFunctions userFunctions = UserFunctions();
  final FirebaseFirestore db = FirebaseFirestore.instance;

  void unFollow() async {
    final currentUser = userFunctions.getCurrentUserEmail();
    Map<String, dynamic>? currentUserInfo = await userFunctions.getInfo(currentUser);
    Map<String, dynamic>? followInfo = await userFunctions.getInfo(name);

    List<dynamic> currentUserFollowing = currentUserInfo?['following'];
    List<dynamic> followInfoFollowers = followInfo?['followers'];

    currentUserFollowing.remove(name);
    followInfoFollowers.remove(currentUser);

    await db.collection('users').doc(currentUser).update({'following': currentUserFollowing});
    await db.collection('users').doc(name).update({'followers': followInfoFollowers});
  }

  void removeFromFollowers() async {
    final currentUser = userFunctions.getCurrentUserEmail();
    Map<String, dynamic>? currentUserInfo = await userFunctions.getInfo(currentUser);
    Map<String, dynamic>? followInfo = await userFunctions.getInfo(name);

    List<dynamic> currentUserFollowers = currentUserInfo?['followers'];
    List<dynamic> followInfoFollowing = followInfo?['following'];

    currentUserFollowers.remove(name);
    followInfoFollowing.remove(currentUser);

    await db.collection('users').doc(currentUser).update({'followers': currentUserFollowers});
    await db.collection('users').doc(name).update({'following': followInfoFollowing});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: Colors.blueGrey.withOpacity(0.3),
      ),
      padding: const EdgeInsets.all(10),
      child: TextButton(
        style: TextButton.styleFrom(foregroundColor: Colors.black),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Profile(isCurrentUser: false, userEmail: name),
            ),
          );
        },
        child: Row(
          children: [
            // ### Profile Picture
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueGrey, width: 2),
                borderRadius: BorderRadius.circular(50),
                color: Colors.cyan,
              ),
              child: ClipOval(
                child: FutureBuilder<String?>(
                  future: userFunctions.getPicture(name),
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
                    String? pictureUrl = snapshot.data;
                    if (pictureUrl == null) {
                      return const Icon(
                        Icons.person_outline_outlined,
                        color: Colors.white,
                        size: 50,
                      );
                    } else {
                      // ### IMAGE ###
                      return FadeInImage.assetNetwork(
                        placeholder: 'assets/images/polite-chicky.gif',
                        image: pictureUrl,
                        fit: BoxFit.cover,
                      );
                    } // Image
                  },
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            // ### User Email
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            const Spacer(),
            // ### Remove Button
            ElevatedButton(
              onPressed: () {
                type == 'Following' ? unFollow() : removeFromFollowers();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Landing(pageIndex: 2)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
              ),
              child: const Text('Remove'),
            ),
          ],
        ),
      ),
    );
  }
}
