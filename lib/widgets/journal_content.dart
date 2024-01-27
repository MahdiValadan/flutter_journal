import 'package:flutter/material.dart';

class JournalContent extends StatelessWidget {
  const JournalContent({
    super.key,
    required this.post,
  });

  final Map<String, dynamic> post;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Center(
            child: Text(
              post['Title'],
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Divider(),
          Container(
            height: 270,
            alignment: Alignment.topLeft,
            child: Scrollbar(
              // thumbVisibility: true,
              child: SingleChildScrollView(
                child: Text(
                  post['Content'],
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
