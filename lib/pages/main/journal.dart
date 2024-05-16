import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_journal/Functions/user_functions.dart';
import 'package:flutter_journal/pages/main/landing.dart';
import 'package:flutter_journal/widgets/journal_content.dart';
import 'package:flutter_journal/widgets/journal_image.dart';
import 'package:flutter_journal/widgets/journal_user_info.dart';
import 'package:logger/logger.dart';

class Journal extends StatefulWidget {
  const Journal({super.key, required this.post});
  final Map<String, dynamic> post;
  @override
  State<Journal> createState() => _JournalState();
}

class _JournalState extends State<Journal> {
  var logger = Logger();
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
          .where('Location', isEqualTo: widget.post['Location'])
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
      logger.e('Error deleting data from Firestore: ', error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[200],
        toolbarHeight: 90,
        title: isCurrentUser ? deleteButton() : JournalUserInfo(post: widget.post),
      ),
      body: Scrollbar(
        trackVisibility: true,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg-white.jpg'),
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Column(
                children: [
                  // ### Journal Image
                  JournalImage(
                    key: const ValueKey('journalImage'),
                    post: widget.post,
                  ),
                  // ### Content
                  JournalContent(
                    key: const ValueKey('journalContent'),
                    post: widget.post,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget deleteButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: FloatingActionButton.small(
          onPressed: () {
            showPrompt(context);
          },
          backgroundColor: Colors.pink,
          elevation: 4,
          child: Icon(
            Icons.delete_forever_outlined,
            size: 30,
            color: Colors.grey[300],
          ),
        ),
      ),
    );
  }

  void showPrompt(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context2) {
        return AlertDialog(
          title: const Text('Warning'),
          content: const Text('Are you sure to delete this post?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context2).pop();
                deletePost();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Landing(pageIndex: 2)),
                );
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
