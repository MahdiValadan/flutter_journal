import 'package:flutter/material.dart';
import 'package:flutter_journal/Functions/user_functions.dart';
import 'package:flutter_journal/pages/main/landing.dart';
import 'package:flutter_journal/pages/main/profile.dart';

class JournalUserInfo extends StatelessWidget {
  JournalUserInfo({
    super.key,
    required this.post,
  });

  final Map<String, dynamic> post;
  final UserFunctions userFunctions = UserFunctions();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
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
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2),
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
      ),
    );
  }
}
