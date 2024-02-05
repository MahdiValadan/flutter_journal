import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
// API
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
// Widget
import 'package:flutter_journal/widgets/alert.dart';
import 'package:flutter_journal/widgets/loading.dart';
// Page
import 'package:flutter_journal/pages/main/landing.dart';

class CreateJournal extends StatefulWidget {
  const CreateJournal({super.key});
  @override
  State<CreateJournal> createState() => _CreateJournalState();
}

class _CreateJournalState extends State<CreateJournal> {
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
  //Location
  final kInitialPosition = const LatLng(-33.8567844, 151.213108);
  String location = "Pick Location";
  // # PICK IMAGE FUNCTION
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

  // # SAVE FUNCTION
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
          'Image': imageUrl,
          'Location': location
        };

        DocumentReference documentReference = await db.collection('posts').add(post);
        String documentId = documentReference.id;

        // Fetch the current data from Firestore
        DocumentSnapshot documentSnapshot = await db.collection('users').doc(email).get();

        Map<String, dynamic> currentData = documentSnapshot.data() as Map<String, dynamic>;

        // Extract the current list from the document
        List<dynamic> newList = currentData['posts'] ?? [];

        // Modify the list (add a new element)
        newList.add(documentId);

        // Update the entire list in Firestore
        await db.collection('users').doc(email).update({'posts': newList});

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

  // WIDGET
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
          : Builder(builder: (context) {
              MediaQueryData mediaQuery = MediaQuery.of(context);
              var screenWidth = mediaQuery.size.width;
              double imageH;
              if (screenWidth > 600) {
                imageH = 350;
              } else {
                imageH = 200;
              }
              return Container(
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue, Colors.white],
                  ),
                ),
                child: Card(
                  elevation: 0,
                  margin: const EdgeInsets.all(0),
                  color: Colors.white.withOpacity(0.4),
                  // Frosted Glass
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              //Post Picture
                              wPicture(imageH),
                              //Space
                              const SizedBox(height: 30),
                              // Title
                              wTitle(),
                              // Space
                              const SizedBox(height: 20),
                              // Content
                              wContent(),
                              // Expanded Space
                              const Expanded(child: SizedBox()),
                              // LOCATION
                              wPickLocationBtn(),
                              // SPACE
                              const SizedBox(height: 20),
                              // SAVE and Cancle Button
                              wSaveAndCancleBtn(context),
                              // SPACE
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
    );
  }

  SizedBox wPickLocationBtn() {
    return SizedBox(
      // height: 50,
      // width: double.infinity,
      child: FloatingActionButton.extended(
        backgroundColor: Colors.orange[700],
        foregroundColor: Colors.white,
        label: Text(location),
        icon: const Icon(Icons.place_outlined),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlacePicker(
                apiKey: "AIzaSyCOwaSNRXoWHCXgZMJIYE3oKuwih4A7QMY",
                initialPosition: kInitialPosition,
                useCurrentLocation: true,
                resizeToAvoidBottomInset:
                    false, // only works in page mode, less flickery, remove if wrong offsets
                onPlacePicked: (PickResult result) {
                  print(result.formattedAddress);
                  setState(() {
                    location = result.formattedAddress ?? "";
                  });
                  Navigator.of(context).pop();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Row wSaveAndCancleBtn(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Button Save
        SizedBox(
          width: 100,
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
                showAlertDialog(
                    context, 'Error', 'Please Choose Image and Enter both title and content');
              }
            },
            child: const Text('Save'),
          ),
        ),
        // Space
        const SizedBox(width: 20),
        // Button Cancel
        SizedBox(
          width: 100,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink[400],
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ),
      ],
    );
  }

  Container wContent() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
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
    );
  }

  TextFormField wTitle() {
    return TextFormField(
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
    );
  }

  InkWell wPicture(double imageH) {
    return InkWell(
      onTap: () {
        pickImage();
      },
      child: Container(
        width: double.infinity,
        height: imageH,
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
    );
  }
}
