import 'dart:ui';
import 'package:flutter/material.dart';

class ViewJournalImage extends StatelessWidget {
  const ViewJournalImage({
    super.key,
    required this.post,
  });

  final Map<String, dynamic> post;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(2, 2), // changes the position of the shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/images/polite-chicky.gif',
          image: post['Image'],
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
