import 'package:cloud_firestore/cloud_firestore.dart';

class PostFunctions {

  // Get All the Posts From Database for Explore Page
  Future<List<Map<String, dynamic>>> getAllData(String collectionName) async {
    List<Map<String, dynamic>> data = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection(collectionName).get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> documentData = documentSnapshot.data() as Map<String, dynamic>;
        data.add(documentData);
      }

      return data;
    } catch (e) {
      print('Error getting data from Firestore: $e');
      return [];
    }
  }

  // Get User post
  Future<List<Map<String, dynamic>>> getDataOfUser(String email) async {
    List<Map<String, dynamic>> data = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts') // Replace with your collection name
          .where('Email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Iterate through the documents and access the data
        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          Map<String, dynamic> documentData = documentSnapshot.data() as Map<String, dynamic>;
          data.add(documentData);
        }
        return data;
      } else {
        return [];
      }
    } catch (e) {
      print('Error getting data from Firestore: $e');
      return [];
    }
  }
}
