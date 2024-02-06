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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Wrap(
            direction: Axis.horizontal,
            children: [
              if (post['Location'].toString().isNotEmpty && post['Location'] != null)
                const Icon(
                  Icons.place_outlined,
                  size: 15,
                ),
              Text(post['Location'] ?? ""),
            ],
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              post['Title'],
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Divider(),
          Text(
            post['Content'],
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
