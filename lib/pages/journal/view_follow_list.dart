import 'package:flutter/material.dart';
import 'package:flutter_journal/widgets/view_follow_card.dart';

class ViewFollowList extends StatelessWidget {
  const ViewFollowList({super.key, required this.followList, required this.title});

  final List followList;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: followList.map((item) {
              return Column(
                children: [
                  ViewFollowCard(name: item, type: title),
                  const SizedBox(height: 20),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
