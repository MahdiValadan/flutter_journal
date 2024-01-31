import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.white],
            ),
          ),
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 40.0,
                sigmaY: 40.0,
              ),
              child: Container(
                constraints: const BoxConstraints.expand(),
                child: Center(
                  child: Lottie.asset('assets/lottie/loading_alt.json', width: 300, height: 300),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
