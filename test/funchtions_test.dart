import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_journal/Functions/user_functions.dart';

void main() {
  setUpAll(() async {
    final instance = FakeFirebaseFirestore();
    await instance.collection('users').doc('test@email.com').set({
      'name': 'test',
    });
  });

  group('Test start', () {
    var userFunction = UserFunctions();

    test('Name of the user "a@a.com" must be "a"', () async {
      expect(userFunction.getName('a@a.com'), 'a');
    });

    test('Check Profile Picture Url of user "a@a.com"', () async {
      expect(
        userFunction.getPicture('a@a.com'),
        'https://firebasestorage.googleapis.com/v0/b/flutter-journal-ea1b4.appspot.com/o/profiles%2Fa%40a.com.jpg?alt=media&token=f4ed68d5-c47b-43b5-8e7a-599578f88ce7',
      );
    });
  });
}