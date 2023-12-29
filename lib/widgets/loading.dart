import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.white,
          constraints: const BoxConstraints.expand(),
          child: Center(
            child: Lottie.asset('/lottie/loading.json', width: 300, height: 300),
          ),
        ),
      ),
    );
  }
}
