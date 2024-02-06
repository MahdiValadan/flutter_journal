import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

class FileUploader {
  var logger = Logger();
  File file;
  String fileName;
  FileUploader(this.file, this.fileName);

  Future<void> uploadFile() async {
    try {
      String fileName = this.fileName;
      Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
      final metadata = SettableMetadata(contentType: 'image/jpeg');
      UploadTask uploadTask = storageReference.putFile(file, metadata);

      await uploadTask.whenComplete(() => logger.i('File uploaded'));
    } catch (e) {
      logger.e("Error uploading file: ", error: e);
    }
  }
}
