import 'package:flutter/material.dart';
import 'package:flutter_journal/Functions/user_functions.dart';
import 'home.dart';
import 'explore.dart';
import 'profile.dart';

class Landing extends StatefulWidget {
  const Landing({super.key, required this.pageIndex});
  final int pageIndex;
  @override
  State<Landing> createState() => LandingState();
}

class LandingState extends State<Landing> {
  int pageIndex = 0;
  UserFunctions userFunctions = UserFunctions();
  @override
  void initState() {
    super.initState();
    pageIndex = widget.pageIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            pageIndex = index;
          });
        },
        indicatorColor: Colors.blue[200],
        selectedIndex: pageIndex,
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
        Profile(
          isCurrentUser: true,
          userEmail: userFunctions.getCurrentUserEmail(),
        ),
      ][pageIndex],
    );
  }
}
