import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
// API
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_journal/Functions/file_uploader.dart';
import 'package:image_picker/image_picker.dart';
// Widget
import 'package:flutter_journal/widgets/alert.dart';
import 'package:flutter_journal/widgets/loading.dart';
// Page
import 'package:flutter_journal/pages/journal/landing.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key, required this.firstTime});
  final bool firstTime;
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // Controllers
  final _formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();

  // Loading Status
  bool isLoading = false;

  // Profile Image
  XFile? image;
  File? pickedImage;
  bool showImage = false;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      image = pickedFile;
      if (image != null) {
        pickedImage = File(image!.path);
        showImage = true;
      }
    });
  }

  // Save Function
  Future<void> save(name, context) async {
    setState(() {
      isLoading = true;
    });
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseFirestore db = FirebaseFirestore.instance;
      String? email = FirebaseAuth.instance.currentUser?.email;
      var user = <String, dynamic>{};
      if (widget.firstTime) {
        user = <String, dynamic>{"Name": name, 'Followers': [], 'Following': [], 'Posts': []};
      } else {
        user = <String, dynamic>{"Name": name};
      }
      // Set New Data
      await db.collection("users").doc(email).set(user);
      if (pickedImage != null) {
        FileUploader fileUploader = FileUploader(pickedImage!, 'profiles/$email.jpg');
        try {
          await fileUploader.uploadFile();
        } catch (e) {
          print(e);
        }
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Landing(pageIndex: 2)),
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
                            //Profile Picture
                            InkWell(
                              onTap: () {
                                pickImage();
                              },
                              child: Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.cyan,
                                ),
                                child: showImage
                                    ? ClipOval(
                                        child: Image.file(pickedImage!, fit: BoxFit.fill),
                                      )
                                    : const Center(
                                        child: Icon(
                                          Icons.add_a_photo_outlined,
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(height: 30),

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

                            const SizedBox(height: 40),

                            // Button Save
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    save(name.text, context);
                                  }
                                },
                                child: const Text('Save'),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Button Cancel
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
                                    MaterialPageRoute(
                                        builder: (context) => const Landing(pageIndex: 2)),
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
