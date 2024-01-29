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
import 'package:flutter_journal/pages/main/landing.dart';
import 'package:lottie/lottie.dart';

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

// *** Pick Image Function
  Future<void> pickImage(ImageSource imageSource) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    setState(() {
      image = pickedFile;
      if (image != null) {
        pickedImage = File(image!.path);
        showImage = true;
      }
    });
  }

  // *** Save Function
  Future<void> save(name, context) async {
    setState(() {
      isLoading = true;
    });
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseFirestore db = FirebaseFirestore.instance;
      String? email = FirebaseAuth.instance.currentUser?.email;

      if (widget.firstTime) {
        // Set New Data
        Map<String, dynamic> user = {
          "name": name,
          'followers': [],
          'following': [],
          'posts': []
        };
        await db.collection("users").doc(email).set(user);
      } else {
        // update name
        await db.collection("users").doc(email).update({"name": name});
      }
      if (pickedImage != null) {
        FileUploader fileUploader =
            FileUploader(pickedImage!, 'profiles/$email.jpg');
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

  // *** Show Pick Image Buttons Functions
  pickeImageBottons() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Gallery'),
                onTap: () {
                  pickImage(ImageSource.gallery);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  pickImage(ImageSource.camera);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final scnheight = MediaQuery.of(context).size.height;
    final scnwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(
      //   title: const Center(child: Text('Flutter Journal')),
      //   backgroundColor: Colors.transparent,
      //   automaticallyImplyLeading: false,
      // ),
      body: isLoading
          ? const Loading()
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg-pastel.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: ListView(
                  children: [
                    // const Text(
                    //   "Welcome",
                    //   style: TextStyle(
                    //     fontSize: 24,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.black, // Set text color to grey
                    //     // shadows: [
                    //     //   Shadow(
                    //     //     color: Color.fromARGB(51, 72, 84, 93),
                    //     //     offset: Offset(2.0, 2.0), // Set shadow offset
                    //     //     blurRadius: 3.0, // Set shadow blur radius
                    //     //   ),
                    //     // ],
                    //   ),
                    // ),
                    Lottie.asset(
                      'assets/lottie/skate.json',
                      height: scnheight / 5,
                      width: scnwidth / 2,
                    ),
                    Card(
                      elevation: 0,
                      // margin: const EdgeInsets.all(10.0),
                      color: Colors.white.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: const BorderSide(
                          color: Colors.black, // Border color
                          width: 1.0, // Border width
                        ),
                      ),
                      // Frosted Glass
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 30),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Text(
                                "Profile",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black, // Set text color to grey
                                  shadows: [
                                    Shadow(
                                      color: Color.fromARGB(51, 72, 84, 93),
                                      offset:
                                          Offset(2.0, 2.0), // Set shadow offset
                                      blurRadius: 3.0, // Set shadow blur radius
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: scnheight / 25,
                              ),
                              //Profile Picture
                              InkWell(
                                onTap: () {
                                  pickeImageBottons();
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
                                          child: Image.file(
                                            pickedImage!,
                                            fit: BoxFit.cover,
                                          ),
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
                                decoration:
                                    const InputDecoration(labelText: 'Name'),
                                controller: name,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null; // Return null if the input is valid.
                                },
                              ),

                              // const SizedBox(height: 40),

                              // // Button Save
                              // SizedBox(
                              //   width: double.infinity,
                              //   height: 50,
                              //   child: ElevatedButton(
                              //     onPressed: () {
                              //       if (_formKey.currentState!.validate()) {
                              //         save(name.text, context);
                              //       }
                              //     },
                              //     child: const Text('Save'),
                              //   ),
                              // ),

                              const SizedBox(height: 20),

                              // Button Cancel
                              // SizedBox(
                              //   width: double.infinity,
                              //   height: 50,
                              //   child: ElevatedButton(
                              //     style: ElevatedButton.styleFrom(
                              //         backgroundColor: Colors.pink[300],
                              //         foregroundColor: Colors.white),
                              //     onPressed: () {
                              //       Navigator.pop(context);
                              //     },
                              //     child: const Text('Cancel'),
                              //   ),
                              // ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  RawMaterialButton(
                                    fillColor:
                                        Color.fromARGB(255, 244, 244, 244),
                                    padding: EdgeInsets.symmetric(
                                      vertical: scnheight / 250,
                                      // horizontal: scnwidth /
                                    ),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    elevation: 10,
                                    splashColor: Colors.red[700],
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  Spacer(),
                                  RawMaterialButton(
                                    fillColor:
                                        Color.fromARGB(255, 255, 255, 255),
                                    padding: EdgeInsets.symmetric(
                                      vertical: scnheight / 250,
                                      // horizontal: scnwidth /
                                    ),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    elevation: 10,
                                    splashColor:
                                        Color.fromARGB(255, 179, 205, 145),
                                    child: const Text(
                                      "Save",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        save(name.text, context);
                                      }
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
