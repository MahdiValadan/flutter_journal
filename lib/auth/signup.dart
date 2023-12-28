import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui';
import 'package:flutter_journal/widgets/alert.dart';

class SignupCard extends StatelessWidget {
  SignupCard({super.key});
  String email = "";
  String password = "";

  void createAccount(emailAddress, password, context) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      showAlertDialog(context, 'Success', 'Your Account has been created.');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showAlertDialog(context, 'Error', 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showAlertDialog(
            context, 'Error', 'The account already exists for that email.');
      }
    } catch (e) {
      showAlertDialog(context, 'Error', e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // CARD
      child: Card(
        elevation: 0,
        color: Colors.white.withOpacity(0.3),
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        // Frosted Glass
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const TextField(
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    onChanged: (text) {
                      email = text;
                    },
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    onChanged: (text) {
                      password = text;
                    },
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => {
                        // showAlertDialog(context)
                        createAccount(email, password, context),
                      },
                      child: const Text('Sign up'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
