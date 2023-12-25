import 'package:flutter/material.dart';
import 'auth/auth.dart';
import 'journal/journal.dart';

void main() {
  bool isAuth = true;
  Widget home = const Auth();
  if (isAuth) {
    home = const Journal();
  }
  runApp(MyApp(home: home));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    this.home,
  });
  final Widget? home;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Journal',
      theme:
          ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan)),
      debugShowCheckedModeBanner: false,
      home: home,
    );
  }
}
