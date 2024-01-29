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
  Widget build(context) {
    final scnHeight = MediaQuery.of(context).size.height;
    final scnWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Card(
        elevation: 0,
        margin: EdgeInsets.all(scnWidth / 10),
        color: Colors.blueGrey.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: const BorderSide(
            color: Colors.blueGrey, // Border color
            width: 1.0, // Border width
          ),
        ),
        // Frosted Glass
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            height: scnHeight / 2.5,
            width: scnWidth,
            padding: EdgeInsets.symmetric(
                horizontal: scnWidth / 22, vertical: scnHeight / 22),
            child: Form(
              key: _formKey,
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    widget.operation,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey, // Set text color to grey
                      shadows: [
                        Shadow(
                          color: Color.fromARGB(51, 72, 84, 93),
                          offset: Offset(2.0, 2.0), // Set shadow offset
                          blurRadius: 3.0, // Set shadow blur radius
                        ),
                      ],
                    ),
                  ),
                  // Email
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                    controller: email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(
                              r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null; // Return null if the input is valid.
                    },
                  ),
                  SizedBox(height: scnHeight / 100),
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
                  SizedBox(height: scnHeight / 20),
                  SizedBox(
                    width: double.infinity,
                    height: scnHeight / 15,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.submit(
                              email.text, password.text, widget.context);
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
