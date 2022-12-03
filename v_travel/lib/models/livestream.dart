import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveStream {
  final String title;
  final String image;
  final String uid;
  final String username;
  final String startedAt;
  final int viewers;
  final String channelId;
  final double latitude;
  final double longitude;

  LiveStream(
      {required this.title,
      required this.image,
      required this.uid,
      required this.username,
      required this.startedAt,
      required this.viewers,
      required this.channelId,
      required this.latitude,
      required this.longitude});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image': image,
      'uid': uid,
      'username': username,
      'viewers': viewers,
      'channelId': channelId,
      'startedAt': startedAt,
      'latitude': latitude,
      'longitude': longitude
    };
  }

  factory LiveStream.fromMap(Map<String, dynamic> map) {
    return LiveStream(
        title: map['title'] ?? '',
        image: map['image'] ?? '',
        uid: map['uid'] ?? '',
        username: map['username'] ?? '',
        startedAt: map['startedAt'] ?? '',
        viewers: map['viewers'] ?? '',
        channelId: map['channelId'] ?? '',
        latitude: map['latitude'] ?? '',
        longitude: map['longitude'] ?? '');
  }
}
