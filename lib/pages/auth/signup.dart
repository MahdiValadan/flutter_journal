import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Pages
import 'package:flutter_journal/pages/journal/edit_profile.dart';
// Widgets
import 'package:flutter_journal/widgets/auth_form.dart';
import 'package:flutter_journal/widgets/alert.dart';
import 'package:flutter_journal/widgets/loading.dart';

class SignupCard extends StatefulWidget {
  const SignupCard({super.key});
  @override
  State<SignupCard> createState() => _SignupCardState();
}

class _SignupCardState extends State<SignupCard> {
  bool isLoading = false;
  // Signup Function
  void signup(email, password, context) async {
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
        MaterialPageRoute(builder: (context) => const EditProfile()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showAlertDialog(context, 'Error', 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showAlertDialog(context, 'Error', 'The account already exists for that email.');
      } else {
        showAlertDialog(context, 'Error', e.message);
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
      child: isLoading
          ? const Loading()
          : AuthForm(
              context: context,
              submit: signup,
              operation: 'Signup',
            ),
    );
  }
}
