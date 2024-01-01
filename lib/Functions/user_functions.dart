import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserFunctions {
  String? email;
  final firebaseAuth = FirebaseAuth.instance;
  final firestoreDB = FirebaseFirestore.instance;
  init() {
    email = firebaseAuth.currentUser?.email;
  }

  // Constructor
  UserFunctions() {
    init();
  }

  Future<String?> getName() async {
    final user = firestoreDB.collection("users").doc(email);
    String name = '';
    await user.get().then(
      (DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        name = data['Name'];
      },
      onError: (e) => print("Error getting document: $e"),
    );
    return name;
  }

  Future<String?> getPicture() async {
    final picturePath = "gs://flutter-journal-ea1b4.appspot.com/$email.jpg";
    final storageReference = FirebaseStorage.instance.refFromURL(picturePath);
    try {
      String downloadURL = await storageReference.getDownloadURL();
      // File exists
      return downloadURL;
    } catch (e) {
      if (e is FirebaseException && e.code == 'object-not-found') {
        // File does not exist
        return null;
      }
      // rethrow; // Other errors
      print('ERROR FirebaseStorage: $e');
      return null;
    }
  }
}
