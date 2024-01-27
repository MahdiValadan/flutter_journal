import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_journal/pages/auth/auth.dart';
import 'package:flutter_journal/pages/main/create_journal.dart';
import 'package:flutter_journal/pages/main/edit_profile.dart';

class ProfileButtons extends StatelessWidget {
  const ProfileButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //Add Post
        FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateJournal()),
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
            Navigator.push(
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
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Auth()),
            );
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
