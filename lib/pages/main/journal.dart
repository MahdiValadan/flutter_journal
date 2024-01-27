import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_journal/Functions/user_functions.dart';
import 'package:flutter_journal/pages/main/landing.dart';
import 'package:flutter_journal/widgets/journal_content.dart';
import 'package:flutter_journal/widgets/journal_image.dart';
import 'package:flutter_journal/widgets/journal_user_info.dart';

class ViewJournal extends StatefulWidget {
  const ViewJournal({super.key, required this.post});
  final Map<String, dynamic> post;
  @override
  State<ViewJournal> createState() => _ViewJournalState();
}

class _ViewJournalState extends State<ViewJournal> {
  UserFunctions userFunctions = UserFunctions();
  late String currentUser;
  bool isCurrentUser = false;
  @override
  void initState() {
    super.initState();
    currentUser = userFunctions.getCurrentUserEmail();
    if (currentUser == widget.post['Email']) {
      isCurrentUser = true;
    }
  }

  // *** DELETE POST FUNCTION ***
  void deletePost() async {
    try {
      // DELETE FROM POSTS
      CollectionReference postCollection = FirebaseFirestore.instance.collection('posts');
      QuerySnapshot querySnapshot = await postCollection
          .where('Content', isEqualTo: widget.post['Content'])
          .where('Email', isEqualTo: widget.post['Email'])
          .where('Image', isEqualTo: widget.post['Image'])
          .where('Title', isEqualTo: widget.post['Title'])
          .get();
      String document = querySnapshot.docs.first.id;
      await postCollection.doc(document).delete();
      // DELETE FROM USER
      CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
      DocumentSnapshot documentSnapshot = await userCollection.doc(currentUser).get();
      Map<String, dynamic> currentData = documentSnapshot.data() as Map<String, dynamic>;
      List<dynamic> userPosts = currentData['posts'];
      userPosts.remove(document);
      await userCollection.doc(currentUser).update({'posts': userPosts});
    } catch (e) {
      print('Error getting data from Firestore: $e');
    }
  }

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
              isCurrentUser ? deleteWidget() : JournalUserInfo(post: widget.post),
              const SizedBox(height: 10),
              // ### Journal Image
              JournalImage(post: widget.post),
              // ### Title
              JournalContent(post: widget.post),
            ],
          ),
        ),
      ),
    );
  }

  Align deleteWidget() {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        onPressed: () {
          showPrompt(context);
        },
        icon: Icon(
          Icons.delete_forever_outlined,
          size: 40,
          color: Colors.red[900],
        ),
      ),
    );
  }

  void showPrompt(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: const Text('Are you sure to delete this post?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Action for the second button
                Navigator.of(context).pop(); // Close the dialog
                deletePost();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Landing(pageIndex: 2)),
                );
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                // Action for the first button
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}
