import 'package:flutter/material.dart';
import 'package:flutter_journal/Functions/user_functions.dart';
import 'package:flutter_journal/pages/journal/landing.dart';
import 'package:flutter_journal/pages/journal/profile.dart';

class ViewJournalUserInfo extends StatelessWidget {
  ViewJournalUserInfo({
    super.key,
    required this.post,
  });

  final Map<String, dynamic> post;
  final UserFunctions userFunctions = UserFunctions();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: Colors.blueGrey.withOpacity(0.3),
      ),
      padding: const EdgeInsets.all(10),
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
                future: userFunctions.getPicture(post['Email']),
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
            post['Email'],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          const Spacer(),
          // ### View User Profile Button
          ElevatedButton(
            onPressed: () {
              if (post['Email'] == userFunctions.getCurrentUserEmail()) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Landing(pageIndex: 2),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profile(isCurrentUser: false, userEmail: post['Email']),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('View Profile'),
          ),
        ],
      ),
    );
  }
}
