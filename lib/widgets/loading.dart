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
            image: DecorationImage(
              image: AssetImage("assets/images/bg-pastel.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 50.0,
                sigmaY: 50.0,
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
