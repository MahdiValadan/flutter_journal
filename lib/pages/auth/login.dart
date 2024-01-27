import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_journal/pages/main/landing.dart';
// Widgets
import 'package:flutter_journal/widgets/alert.dart';
import 'package:flutter_journal/widgets/auth_form.dart';
import 'package:flutter_journal/widgets/loading.dart';

class LoginCard extends StatefulWidget {
  const LoginCard({super.key});

  @override
  State<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  // Loading Handler
  bool isLoading = false;

  // Login Function
  Future<void> loginToAccount(email, password, context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Landing(pageIndex: 0)),
      );
      // showAlertDialog(context, 'Success', 'OK');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showAlertDialog(context, 'Error', 'Wrong email or password.');
      } else {
        showAlertDialog(context, 'Error', e.code);
      }
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
          : AuthForm(
              context: context,
              submit: loginToAccount,
              operation: 'Login',
            ),
    );
  }
}
