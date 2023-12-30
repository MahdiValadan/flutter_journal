import 'package:flutter/material.dart';
import 'package:flutter_journal/widgets/profile_buttons.dart';
import 'package:flutter_journal/widgets/profile_info.dart';
import 'package:flutter_journal/widgets/profile_picture.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(flex: 2, child: ProfilePicture()),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Richie Lorie",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  const ProfileButtons(),
                  const SizedBox(height: 30),
                  const ProfileInfo(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
