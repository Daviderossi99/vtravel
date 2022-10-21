import 'package:flutter/material.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  List<Widget> lives = [];
  @override
  Widget build(BuildContext context) {
    int liveCount = 4;
    for (int i = 0; i < liveCount; i++) {
      lives.add(ListTile(title: Text('if there a live this gonna show up $i')));
    }

    return liveCount == 0
        ? const Center(child: Text('Empty'))
        : ListView.builder(
            itemCount: liveCount,
            itemBuilder: (BuildContext context, int index) {
              return lives[index];
            });
  }
}
