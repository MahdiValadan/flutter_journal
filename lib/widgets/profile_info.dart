import 'package:flutter/material.dart';
import 'package:flutter_journal/models/profile_info_item.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({super.key, required this.info});
  final Map<String, dynamic> info;
  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  late List<ProfileInfoItem> items;
  init() {
    int posts = widget.info['posts'].length;
    int followers = widget.info['followers'].length;
    int following = widget.info['following'].length;
    setState(
      () {
        items = [
          ProfileInfoItem("Posts", posts),
          ProfileInfoItem("Followers", followers),
          ProfileInfoItem("Following", following)
        ];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items
            .map((item) => Expanded(
                    child: Row(
                  children: [
                    if (items.indexOf(item) != 0) const VerticalDivider(),
                    Expanded(child: _singleItem(context, item)),
                  ],
                )))
            .toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.value.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Text(
            item.title,
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      );
}
