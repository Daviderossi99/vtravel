import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:v_travel/screens/search_screen.dart';
import 'package:v_travel/utils/colors.dart';
import '../models/livestream.dart';
import '../resources/firestore_methods.dart';
import 'broadcast_screen.dart';
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
  bool markerClicked = false;
  List<Widget> pages = [];
  Map<String, dynamic>? liveStream;

  @override
  void initState() {
    super.initState();
    pages = [
      ExploreScreen(callBack),
      const BrowseScreen(),
      const GoLiveScreen(),
      const FavoriteScreen(),
      const SearchScreen()
    ];
  }

  void callBack(markerClicked, liveStream) {
    setState(() {
      this.markerClicked = markerClicked;
      this.liveStream = liveStream;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;

    return Scaffold(
      body: pages[_page],
      floatingActionButton: showFab
          ? FloatingActionButton(
              onPressed: !markerClicked
                  ? () => setState(() {
                        _page = 2;
                      })
                  : () async {
                      setState(() {
                        markerClicked = false;
                      });
                      LiveStream post = LiveStream.fromMap(liveStream!);
                      await FirestoreMethods()
                          .updateViewCount(post.channelId, true);
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BroadcastScreen(
                            isBroadcaster: false,
                            channelId: post.channelId,
                          ),
                        ),
                      );
                    },
              focusColor: primaryColor,
              backgroundColor: _page == 2 ? buttonColor : Colors.blue[200],
              child: markerClicked
                  ? const Icon(FontAwesomeIcons.rightToBracket)
                  : const Icon(Icons.add),
            )
          : null,
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
