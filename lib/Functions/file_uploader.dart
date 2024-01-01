import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FileUploader {
  File file;
  String fileName;
  FileUploader(this.file, this.fileName);

  Future<void> uploadFile() async {
    try {
      String fileName = this.fileName;
      Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
      final metadata = SettableMetadata(contentType: 'image/jpeg');
      UploadTask uploadTask = storageReference.putFile(file, metadata);

      await uploadTask.whenComplete(() => print('File uploaded'));
    } catch (e) {
      print('Error uploading file: $e');
    }
  }
}
