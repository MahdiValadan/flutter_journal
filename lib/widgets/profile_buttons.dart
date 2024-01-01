import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_journal/pages/auth/auth.dart';
import 'package:flutter_journal/pages/journal/create_post.dart';
import 'package:flutter_journal/pages/journal/edit_profile.dart';

class ProfileButtons extends StatelessWidget {
  const ProfileButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Follow Button
        // FloatingActionButton.extended(
        //   onPressed: () {},
        //   heroTag: 'follow',
        //   elevation: 0,
        //   label: const Text("Follow"),
        //   icon: const Icon(Icons.person_add_alt_1),
        // ),

        //Add Post
        FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const CreatePost()),
            );
          },
          heroTag: 'Add Post',
          elevation: 0,
          label: const Text("Add Post"),
          icon: const Icon(Icons.post_add_outlined),
        ),

        const SizedBox(width: 16.0),

        // Edit Button
        FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const EditProfile(firstTime: false)),
            );
          },
          heroTag: 'Edit Info',
          elevation: 0,
          label: const Text("Edit Info"),
          icon: const Icon(Icons.edit_outlined),
          backgroundColor: Colors.green[100],
        ),

        const SizedBox(width: 16.0),

        // Logout Button
        FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Auth()),
            );
            FirebaseAuth.instance.signOut();
          },
          heroTag: 'logout',
          elevation: 0,
          backgroundColor: Colors.pink[100],
          label: const Text("Logout"),
          icon: const Icon(Icons.logout_outlined),
        ),
      ],
    );
  }
}
