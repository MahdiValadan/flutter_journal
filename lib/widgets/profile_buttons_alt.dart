import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileButtonsAlt extends StatelessWidget {
  const ProfileButtonsAlt({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Follow Button
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton.extended(
          onPressed: () {},
          heroTag: 'follow',
          elevation: 0,
          label: const Text("Follow"),
          icon: const Icon(Icons.person_add_alt_1),
          backgroundColor: Colors.purple[100],
        ),
        const SizedBox(width: 20.0),
        FloatingActionButton.extended(
          onPressed: () {
            Navigator.pop(context);
          },
          heroTag: 'logout',
          elevation: 0,
          backgroundColor: Colors.pink[100],
          label: const Text("Close"),
          icon: const Icon(Icons.close_rounded),
        )
      ],
    );
  }
}
