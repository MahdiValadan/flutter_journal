import 'package:flutter/material.dart';
import 'dart:ui';

class SignupCard extends StatelessWidget {
  const SignupCard({super.key});
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
                  const TextField(
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 20),
                  const TextField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle login logic here
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
