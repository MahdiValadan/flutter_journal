import 'package:flutter/material.dart';
import 'auth/auth.dart';
import 'journal/journal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Journal',
      theme:
          ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan)),
      debugShowCheckedModeBanner: false,
      home: const Journal(),
    );
  }
}
