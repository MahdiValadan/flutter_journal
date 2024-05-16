import 'package:flutter/material.dart';
import 'package:flutter_journal/models/profile_info_item.dart';
import 'package:flutter_journal/pages/main/follow_list.dart';
import 'package:flutter_journal/pages/main/journal_list.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo(
      {super.key, required this.info, required this.userEmail, required this.isCurrentUser});
  final Map<String, dynamic> info;
  final String userEmail;
  final bool isCurrentUser;
  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  late List<ProfileInfoItem> items;
  late List followers;
  late List following;
  late List posts;
  init() {
    posts = widget.info['posts'];
    followers = widget.info['followers'];
    following = widget.info['following'];
    setState(
      () {
        items = [
          ProfileInfoItem("Posts", posts.length),
          ProfileInfoItem("Followers", followers.length),
          ProfileInfoItem("Following", following.length)
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
            .map(
              (item) => Expanded(
                child: Row(
                  children: [
                    if (items.indexOf(item) != 0) const VerticalDivider(),
                    Expanded(
                      key: ValueKey('profileInfoItem-${items.indexOf(item)}'),
                      child: _singleItem(
                        context,
                        item,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () => {
              if (item.title == 'Followers' && widget.isCurrentUser)
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FollowList(
                        followList: followers,
                        title: 'Followers',
                      ),
                    ),
                  )
                }
              else if (item.title == 'Following' && widget.isCurrentUser)
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FollowList(
                        followList: following,
                        title: 'Following',
                      ),
                    ),
                  )
                }
              else if (item.title == 'Posts')
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JournalList(userEmail: widget.userEmail),
                    ),
                  )
                }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                item.value.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
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
