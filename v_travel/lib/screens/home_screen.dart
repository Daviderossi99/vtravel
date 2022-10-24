import 'package:flutter/material.dart';
import 'package:v_travel/utils/colors.dart';

import 'explore_screen.dart';
import 'go_live_screen.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  onPageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  List<Widget> pages = const [
    ExploreScreen(),
    GoLiveScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VTravel'),
      ),
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: buttonColor,
        unselectedItemColor: primaryColor,
        backgroundColor: backgroundColor,
        onTap: onPageChange,
        currentIndex: _page,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(
              icon: Icon(Icons.video_camera_back), label: 'Go live')
        ],
      ),
    );
  }
}
