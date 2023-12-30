import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_journal/pages/journal.dart';
import 'package:flutter_journal/widgets/alert.dart';
import 'dart:ui';

import 'package:flutter_journal/widgets/loading.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // Controllers
  final _formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController bio = TextEditingController();
  bool isLoading = false;
  // Create Function
  Future<void> save(name, bio, context) async {
    setState(() {
      isLoading = true;
    });
    if (FirebaseAuth.instance.currentUser != null) {
      String? email = FirebaseAuth.instance.currentUser?.email;
      FirebaseFirestore db = FirebaseFirestore.instance;
      final user = <String, dynamic>{"Name": name, "Bio": bio};
      await db.collection("users").doc(email).set(user);
      showAlertDialog(context, 'Success', 'Your Account has been Created');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Journal()),
      );
    } else {
      showAlertDialog(context, 'Error', 'Error');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Flutter Journal')),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Loading()
          : Container(
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg-pastel.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Card(
                elevation: 0,
                margin: const EdgeInsets.all(20.0),
                color: Colors.white.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: const BorderSide(
                    color: Colors.black, // Border color
                    width: 1.0, // Border width
                  ),
                ),
                // Frosted Glass
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            // Name
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Name'),
                              controller: name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null; // Return null if the input is valid.
                              },
                            ),
                            const SizedBox(height: 20),
                            // bio
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'bio'),
                              controller: bio,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your bio';
                                }
                                return null; // Return null if the input is valid.
                              },
                            ),
                            // Button Save
                            const SizedBox(height: 40),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    save(name.text, bio.text, context);
                                  }
                                },
                                child: const Text('Save'),
                              ),
                            ),
                            // Button Cancel
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pink[300],
                                    foregroundColor: Colors.white),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const Journal()),
                                  );
                                },
                                child: const Text('Cancel'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
