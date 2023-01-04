import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/livestream.dart';
import '../resources/firestore_methods.dart';
import '../screens/broadcast_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class MobileLiveCard extends StatefulWidget {
  final Map<String, dynamic> liveStream;

  const MobileLiveCard(this.liveStream, {super.key});

  @override
  State<MobileLiveCard> createState() => _MobileLiveCardState();
}

class _MobileLiveCardState extends State<MobileLiveCard> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    LiveStream post = LiveStream.fromMap(widget.liveStream);
    return InkWell(
      onTap: () async {
        await FirestoreMethods().updateViewCount(post.channelId, true);
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
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.7),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        height: size.height * 0.13,
        width: size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: size.width * 0.5,
              height: size.height * 0.15,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.only(topLeft: Radius.circular(10)),
                child: Image.network(
                  post.image,
                  height: size.height * 0.15,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(width: 5),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  post.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.solidEye,
                      size: 12,
                    ),
                    Text('  ${post.viewers}'),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 30),
                    const Icon(
                      FontAwesomeIcons.solidClock,
                      size: 12,
                    ),
                    Text(
                        '  ${timeago.format(DateTime.parse(post.startedAt.toString()))}'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
