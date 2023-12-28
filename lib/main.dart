import 'package:flutter/material.dart';
import 'auth/auth.dart';
import 'journal/journal.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  bool isAuth = false;
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
