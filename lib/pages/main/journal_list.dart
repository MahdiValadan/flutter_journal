import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_journal/Functions/post_functions.dart';
import 'package:flutter_journal/widgets/journal_preview.dart';

class JournalList extends StatelessWidget {
  JournalList({super.key, required this.userEmail});
  final String userEmail;
  final PostFunctions postFunctions = PostFunctions();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Journals')),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueGrey, Colors.white],
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: FutureBuilder<List<Map<String, dynamic>>>(
              future: postFunctions.getDataOfUser(userEmail),
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
        ),
      ),
    );
  }
}
