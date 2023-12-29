import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Pages
import 'package:flutter_journal/journal/journal.dart';
// Widgets
import 'package:flutter_journal/widgets/alert.dart';
import 'package:flutter_journal/widgets/loading.dart';

class SignupCard extends StatefulWidget {
  const SignupCard({super.key});
  @override
  State<SignupCard> createState() => _SignupCardState();
}

class _SignupCardState extends State<SignupCard> {
  String email = "";
  String password = "";
  bool isLoading = false;

  void createAccount(email, password, context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      showAlertDialog(context, 'Success', 'Your Account has been created.');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Journal()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showAlertDialog(context, 'Error', 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showAlertDialog(context, 'Error', 'The account already exists for that email.');
      }
    } catch (e) {
      showAlertDialog(context, 'Error', e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // CARD
      child: isLoading
          ? const Loading()
          : Card(
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
