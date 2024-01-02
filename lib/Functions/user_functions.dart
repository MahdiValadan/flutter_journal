import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserFunctions {
  late String currentUserEmail;

  final firebaseAuth = FirebaseAuth.instance;
  final firestoreDB = FirebaseFirestore.instance;

  init() {
    currentUserEmail = firebaseAuth.currentUser?.email ?? '';
  }

  // Constructor
  UserFunctions() {
    init();
  }

  String getCurrentUserEmail() {
    return currentUserEmail;
  }

  // Get Name of a user
  Future<String?> getName(String email) async {
    final user = firestoreDB.collection("users").doc(email);
    Map<String, dynamic> data;
    String? name;
    await user.get().then(
      (DocumentSnapshot doc) {
        data = doc.data() as Map<String, dynamic>;
        name = data['name'];
      },
      onError: (e) => print("Error getting document: $e"),
    );
    return name;
  }

  // get info of a user
  Future<Map<String, dynamic>?> getInfo(String email) async {
    final user = firestoreDB.collection("users").doc(email);
    Map<String, dynamic>? data;
    await user.get().then(
      (DocumentSnapshot doc) {
        data = doc.data() as Map<String, dynamic>;
      },
      onError: (e) => print("Error getting document: $e"),
    );
    return data;
  }

  //get picture of a user
  Future<String?> getPicture(String email) async {
    final picturePath = "gs://flutter-journal-ea1b4.appspot.com/profiles/$email.jpg";
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
