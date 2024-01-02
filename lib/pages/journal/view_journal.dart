import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_journal/widgets/view_journal_content.dart';
import 'package:flutter_journal/widgets/view_journal_image.dart';
import 'package:flutter_journal/widgets/view_journal_user_info.dart';

class ViewJournal extends StatelessWidget {
  const ViewJournal({super.key, required this.post});
  final Map<String, dynamic> post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg-white.jpg'),
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Column(
            children: [
              // ### User info
              ViewJournalUserInfo(post: post),
              const SizedBox(height: 10),
              // ### Journal Image
              ViewJournalImage(post: post),
              // ### Title
              ViewJournalContent(post: post),
            ],
          ),
        ),
      ),
    );
  }
}
