import 'package:flutter/material.dart';

class JournalImage extends StatelessWidget {
  const JournalImage({
    super.key,
    required this.post,
  });

  final Map<String, dynamic> post;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var screenWidth = mediaQuery.size.width;
    double imageH;
    double m;
    if (screenWidth > 600) {
      imageH = 400;
      m = 20;
    } else {
      imageH = 250;
      m = 10;
    }
    return Container(
      margin: EdgeInsets.all(m),
      width: double.infinity,
      height: imageH,
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
