import 'package:flutter/material.dart';
import 'package:flutter_journal/Functions/user_functions.dart';
import 'package:flutter_journal/widgets/profile_buttons.dart';
import 'package:flutter_journal/widgets/profile_info.dart';
import 'package:flutter_journal/widgets/profile_name.dart';
import 'package:flutter_journal/widgets/profile_picture.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final UserFunctions userFunctions = UserFunctions();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: ProfilePicture(),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Space
                  const SizedBox(height: 20),
                  // Profile Name
                  FutureBuilder<String?>(
                    future: userFunctions.getName(),
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
                  const SizedBox(height: 20),
                  // Profile Buttons
                  const ProfileButtons(),
                  // Space
                  const SizedBox(height: 20),
                  // Profile Info
                  FutureBuilder<Map<String, dynamic>?>(
                    future: userFunctions.getInfo(),
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
        ],
      ),
    );
  }
}
