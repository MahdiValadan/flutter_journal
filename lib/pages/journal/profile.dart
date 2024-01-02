import 'package:flutter/material.dart';
import 'package:flutter_journal/Functions/post_functions.dart';
import 'package:flutter_journal/Functions/user_functions.dart';
import 'package:flutter_journal/widgets/journal_preview.dart';
import 'package:flutter_journal/widgets/profile_buttons.dart';
import 'package:flutter_journal/widgets/profile_buttons_alt.dart';
import 'package:flutter_journal/widgets/profile_info.dart';
import 'package:flutter_journal/widgets/profile_name.dart';
import 'package:flutter_journal/widgets/profile_picture.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.isCurrentUser, required this.userEmail});
  final bool isCurrentUser;
  final String userEmail;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final UserFunctions userFunctions = UserFunctions();
  final PostFunctions postFunctions = PostFunctions();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Profile Picture
          Expanded(
            flex: 2,
            child: ProfilePicture(email: widget.userEmail),
          ),

          // Profile name & buttons & info
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Space
                  const SizedBox(height: 20),
                  // Profile Name
                  FutureBuilder<String?>(
                    future: userFunctions.getName(widget.userEmail),
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
                      String name = snapshot.data ?? '';
                      // Build your UI using the result
                      return ProfileName(name: name);
                    },
                  ),
                  // Space
                  const SizedBox(height: 30),
                  // Profile Buttons
                  widget.isCurrentUser
                      ? const ProfileButtons()
                      : ProfileButtonsAlt(profileUser: widget.userEmail),
                  // Space
                  const SizedBox(height: 30),
                  // Profile Info
                  FutureBuilder<Map<String, dynamic>?>(
                    future: userFunctions.getInfo(widget.userEmail),
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
                      Map<String, dynamic>? data = snapshot.data ?? {};
                      // Build your UI using the result
                      return ProfileInfo(info: data);
                    },
                  )
                ],
              ),
            ),
          ),

          // Current user's posts
          Expanded(
            flex: 2,
            child: FutureBuilder<List<Map<String, dynamic>>>(
                future: postFunctions.getDataOfUser(widget.userEmail),
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
                  List<Map<String, dynamic>> posts = snapshot.data ?? [];

                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (BuildContext context, int index) {
                      final post = posts[index];
                      return JournalPreview(post: post);
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}
