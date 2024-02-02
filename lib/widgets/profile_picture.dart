import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_journal/Functions/user_functions.dart';
import 'package:flutter_journal/pages/auth/auth.dart';

class ProfilePicture extends StatelessWidget {
  ProfilePicture({super.key, required this.email, required this.isCurrentUser});
  final String email;
  final UserFunctions userFunctions = UserFunctions();
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Blue Box
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.lightBlue, Colors.cyan],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),
        // Logout Button
        Visibility(
          visible: isCurrentUser,
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
              child: FloatingActionButton.small(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Auth()),
                  );
                },
                heroTag: 'logout',
                elevation: 2,
                backgroundColor: Colors.pink[200],
                child: const Icon(Icons.logout_outlined),
              ),
            ),
          ),
        ),
        // IMAGE
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.amber[800],
                    shape: BoxShape.circle,
                  ),
                  child: FutureBuilder<String?>(
                    future: userFunctions.getPicture(email),
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
                          size: 80,
                        );
                      } else {
                        // ### IMAGE ###
                        return ClipOval(
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/polite-chicky.gif',
                            image: pictureUrl,
                            fit: BoxFit.cover,
                          ),
                        );
                      } // Image
                    },
                  ),
                ),

                // ### Green Circle Indicator ###
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
