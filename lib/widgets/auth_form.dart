import 'package:flutter/material.dart';
import 'dart:ui';

class AuthForm extends StatefulWidget {
  const AuthForm({
    super.key,
    required this.context,
    required this.submit,
    required this.operation,
  });
  final BuildContext context;
  final Function(String, String, BuildContext) submit;
  final String operation;
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  // Form Controllers
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  //
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(30.0),
      color: Colors.blueGrey.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: const BorderSide(
          color: Colors.blueGrey, // Border color
          width: 1.0, // Border width
        ),
      ),
      // Frosted Glass
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Email
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                    controller: email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null; // Return null if the input is valid.
                    },
                  ),
                  const SizedBox(height: 20),
                  // Passworld
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    controller: password,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Password';
                      }
                      return null; // Return null if the input is valid.
                    },
                  ),
                  const SizedBox(height: 44),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.submit(email.text, password.text, widget.context);
                          // loginToAccount(email, password, context);
                        }
                      },
                      child: Text(widget.operation),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
