import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_journal/Functions/post_functions.dart';
import 'package:flutter_journal/widgets/journal_preview.dart';
import 'package:lottie/lottie.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PostFunctions postFunctions = PostFunctions();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg-pastel.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          margin: const EdgeInsets.only(top: 40),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: FutureBuilder<List<Map<String, dynamic>>>(
                future: postFunctions.getFollowingPosts(),
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

                  if (posts.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Follow others to see their posts 🐻',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Lottie.asset('assets/lottie/skate.json', width: 300, height: 300),
                      ],
                    );
                  }
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
