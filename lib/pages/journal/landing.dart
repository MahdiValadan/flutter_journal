import 'package:flutter/material.dart';
import 'home.dart';
import 'explore.dart';
import 'profile.dart';

class Landing extends StatefulWidget {
  
  Landing({super.key, required this.currentPageIndex});
  int currentPageIndex;

  @override
  State<Landing> createState() => LandingState();
}

class LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            widget.currentPageIndex = index;
          });
        },
        indicatorColor: Colors.blue[200],
        selectedIndex: widget.currentPageIndex,
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
            selectedIcon: Icon(Icons.account_circle),
            icon: Icon(Icons.account_circle_outlined),
            label: 'Proflie',
          ),
        ],
      ),
      body: <Widget>[
        const Home(),
        const Explore(),
        const Profile(),
      ][widget.currentPageIndex],
    );
  }
}
