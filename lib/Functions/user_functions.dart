import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

class UserFunctions {
  bool? isTesting;
  var logger = Logger();
  late String currentUserEmail;
  final firebaseAuth = FirebaseAuth.instance;
  final firestoreDB = FirebaseFirestore.instance;
  // Constructor
  UserFunctions([this.isTesting]) {
    if (isTesting != null) {
      currentUserEmail = 'test@test.com';
    } else {
      currentUserEmail = firebaseAuth.currentUser?.email ?? '';
    }
  }

  // Get Corrent User
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
      onError: (e) => logger.e("Error getting document: ", error: e),
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
      onError: (e) => logger.e("Error getting document: ", error: e),
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
      logger.e('ERROR FirebaseStorage: ', error: e);
      return null;
    }
  }
}
