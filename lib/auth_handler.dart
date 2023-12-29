import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Pages
import 'package:flutter_journal/auth/auth.dart';
import 'package:flutter_journal/journal/journal.dart';
import 'package:flutter_journal/widgets/loading.dart';

class AuthHandler extends StatelessWidget {
  const AuthHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;

          if (user == null) {
            // User is signed out, navigate to the sign-in screen
            return const Auth();
          } else {
            // User is signed in, navigate to the home screen
            return const Journal();
          }
        } else {
          // Loading state, show a loading indicator or splash screen
          return const Loading();
        }
      },
    );
  }
}
