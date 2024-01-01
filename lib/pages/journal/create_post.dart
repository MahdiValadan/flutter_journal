import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
// API
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

// Widget
import 'package:flutter_journal/widgets/alert.dart';
import 'package:flutter_journal/widgets/loading.dart';

// Page
import 'package:flutter_journal/pages/journal/landing.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  // Controllers
  final _formKey = GlobalKey<FormState>();
  final TextEditingController title = TextEditingController();
  final TextEditingController content = TextEditingController();

  // Loading Status
  bool isLoading = false;

  // Profile Image
  XFile? image;
  late File pickedImage;
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

      const uuid = Uuid();
      String imageName = uuid.v4();
      String imageUrl;

      final Reference storageReference =
          FirebaseStorage.instance.ref().child('posts/$email/$imageName.jpg');
      final metadata = SettableMetadata(contentType: 'image/jpeg');

      try {
        await storageReference.putFile(pickedImage, metadata);
        imageUrl = await storageReference.getDownloadURL();

        var post = <String, dynamic>{
          'Email': email,
          'Title': title.text,
          'Content': content.text,
          'Image': imageUrl
        };

        await db.collection("posts").add(post);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Landing(pageIndex: 2)),
        );
      } catch (e) {
        showAlertDialog(context, 'Error', e.toString());
      }
    } else {
      showAlertDialog(context, 'Error', 'Invalid Access');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Center(child: Text('Create Post')),
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
                margin: const EdgeInsets.all(10.0),
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
                            //Post Picture
                            InkWell(
                              onTap: () {
                                pickImage();
                              },
                              child: Container(
                                width: double.infinity,
                                height: 200.0,
                                decoration: BoxDecoration(
                                  color: Colors.cyan,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: showImage
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(pickedImage, fit: BoxFit.fill),
                                      )
                                    : const Center(
                                        child: Icon(
                                          Icons.add_photo_alternate_outlined,
                                          color: Colors.white,
                                          size: 60,
                                        ),
                                      ),
                              ),
                            ),

                            //Space
                            const SizedBox(height: 30),

                            // Title
                            TextFormField(
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                labelText: 'Title',
                                // border: OutlineInputBorder(),
                              ),
                              controller: title,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your journal title';
                                }
                                return null; // Return null if the input is valid.
                              },
                            ),

                            // Space
                            const SizedBox(height: 20),

                            // Content
                            Container(
                              constraints: BoxConstraints(maxHeight: 300),
                              child: TextFormField(
                                keyboardType: TextInputType.multiline,
                                decoration: const InputDecoration(
                                  labelText: 'Content',
                                  hintText: 'This is My Journay!! 🦊',
                                  border: OutlineInputBorder(),
                                ),
                                controller: content,
                                maxLines: null,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please write your journal';
                                  }
                                  return null; // Return null if the input is valid.
                                },
                              ),
                            ),

                            const Expanded(child: SizedBox()),

                            // Button Save
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[400],
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate() && showImage) {
                                    save(content.text, context);
                                  } else {
                                    showAlertDialog(context, 'Error',
                                        'Please Choose Image and Enter both title and content');
                                  }
                                },
                                child: const Text('Save'),
                              ),
                            ),

                            // Space
                            const SizedBox(height: 20),

                            // Button Cancel
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pink[400],
                                  foregroundColor: Colors.white,
                                ),
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
