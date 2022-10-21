import 'package:flutter/material.dart';

import '../explore.dart';
import '../live_page.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPage = 0;
  List<Widget> pages = const [Explore(), LivePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VTravel'),
      ),
      body: pages[currentPage],
      /*floatingActionButton:
          FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)),*/
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.explore), label: 'Explore'),
          NavigationDestination(
              icon: Icon(Icons.video_camera_back), label: 'Start a live')
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}
