import 'package:flutter/material.dart';
import 'home.dart';
import 'explore.dart';
import 'profile.dart';
import 'message.dart';

class Journal extends StatefulWidget {
  const Journal({super.key});
  @override
  State<Journal> createState() => JournalState();
}

class JournalState extends State<Journal> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.cyan,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.explore),
            icon: Icon(Icons.explore_outlined),
            label: 'Explore',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.chat_bubble),
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Messages',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.account_circle),
            icon: Icon(Icons.account_circle_outlined),
            label: 'Proflie',
          ),
        ],
      ),
      body: <Widget>[
        const Home(),
        const Explore(),
        const Message(),
        const Profile(),
      ][currentPageIndex],
    );
  }
}
