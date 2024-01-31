import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_journal/Functions/post_functions.dart';
import 'package:flutter_journal/widgets/journal_preview.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  PostFunctions postFunctions = PostFunctions();
  // late List<Map<String, dynamic>> posts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg-art.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          margin: const EdgeInsets.only(top: 40),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 150, sigmaY: 150),
            child: FutureBuilder<List<Map<String, dynamic>>>(
                future: postFunctions.getAllData('posts'),
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
      ),
    );
  }
}
