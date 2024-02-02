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
          elevation: 2,
          label: const Text("Create Journal"),
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
          elevation: 2,
          label: const Text("Edit Info"),
          icon: const Icon(Icons.edit_outlined),
          backgroundColor: Colors.green[100],
        ),
      ],
    );
  }
}
