import 'package:flutter/material.dart';
import 'package:v_travel/screens/search_screen.dart';
import 'package:v_travel/utils/colors.dart';

import 'browse_screen.dart';
import 'explore_screen.dart';
import 'favorite_screen.dart';
import 'go_live_screen.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;

  List<Widget> pages = const [
    ExploreScreen(),
    BrowseScreen(),
    GoLiveScreen(),
    FavoriteScreen(),
    SearchScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_page],
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          _page = 2;
        }),
        focusColor: primaryColor,
        backgroundColor: _page == 2 ? buttonColor : Colors.blue[200],
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: SizedBox(
          height: 60,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MaterialButton(
                  minWidth: 40,
                  onPressed: () => setState(() {
                    _page = 0;
                  }),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.explore,
                        color: _page == 0 ? buttonColor : Colors.grey,
                        size: _page == 0 ? 30 : 25,
                      ),
                      Text(
                        'Explore',
                        style: TextStyle(
                          color: _page == 0 ? buttonColor : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MaterialButton(
                  minWidth: 40,
                  onPressed: () => setState(() {
                    _page = 1;
                  }),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.copy,
                        color: _page == 1 ? buttonColor : Colors.grey,
                        size: _page == 1 ? 30 : 25,
                      ),
                      Text(
                        'Browse',
                        style: TextStyle(
                          color: _page == 1 ? buttonColor : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () => setState(() {
                      _page = 3;
                    }),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite,
                          color: _page == 3 ? buttonColor : Colors.grey,
                          size: _page == 3 ? 30 : 25,
                        ),
                        Text(
                          'Favorite',
                          style: TextStyle(
                            color: _page == 3 ? buttonColor : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MaterialButton(
                  minWidth: 40,
                  onPressed: () => setState(() {
                    _page = 4;
                  }),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        color: _page == 4 ? buttonColor : Colors.grey,
                        size: _page == 4 ? 30 : 25,
                      ),
                      Text(
                        'Search',
                        style: TextStyle(
                          color: _page == 4 ? buttonColor : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
