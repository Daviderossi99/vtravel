import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:v_travel/providers/user_provider.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:v_travel/resources/firestore_methods.dart';
import 'package:v_travel/responsive/responsive_layout.dart';
import 'package:v_travel/screens/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:v_travel/widgets/custom_button.dart';
import '../config/appid.dart';
import '../widgets/chat.dart';

class BroadcastScreen extends StatefulWidget {
  final bool isBroadcaster;
  final String channelId;
  const BroadcastScreen(
      {super.key, required this.isBroadcaster, required this.channelId});

  @override
  State<BroadcastScreen> createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  late final RtcEngine _engine;
  List<int> remoteUid = [];
  bool switchCamera = true;
  bool isMuted = false;

  @override
  void initState() {
    super.initState();
    _initEngine();
  }

  void _initEngine() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(appId));
    _addListeners();

    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    if (widget.isBroadcaster) {
      _engine.setClientRole(ClientRole.Broadcaster);
    } else {
      _engine.setClientRole(ClientRole.Audience);
    }
    _joinChannel();
  }

  String baseUrl = "https://vtravel-server.herokuapp.com";

  String? token;

  Future<void> getToken() async {
    final res = await http.get(
      Uri.parse(
          '$baseUrl/rtc/${widget.channelId}/publisher/userAccount/${Provider.of<UserProvider>(context, listen: false).user.uid}/'),
    );

    if (res.statusCode == 200) {
      setState(() {
        token = res.body;
        token = jsonDecode(token!)['rtcToken'];
      });
    } else {
      debugPrint('Failed to fetch the token');
    }
  }

  void _addListeners() {
    _engine.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (channel, uid, elapsed) {
        debugPrint('joinChannelSuccess $channel $uid $elapsed');
      },
      userJoined: (uid, elapsed) {
        debugPrint('userJoined $uid $elapsed');
        setState(() {
          remoteUid.add(uid);
        });
      },
      userOffline: (uid, reason) {
        debugPrint('userOffline $uid $reason');
        setState(() {
          remoteUid.removeWhere((element) => element == uid);
        });
      },
      leaveChannel: (stats) {
        debugPrint('leaveChannel $stats');
        setState(() {
          remoteUid.clear();
        });
      },
      tokenPrivilegeWillExpire: (token) async {
        await getToken();
        await _engine.renewToken(token);
      },
    ));
  }

  void _joinChannel() async {
    await getToken();
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }
    await _engine.joinChannelWithUserAccount(
        token,
        widget.channelId,
        // ignore: use_build_context_synchronously
        Provider.of<UserProvider>(
          context,
          listen: false,
        ).user.uid);
  }

  _leaveChannel() async {
    await _engine.leaveChannel();
    // ignore: use_build_context_synchronously
    if (Provider.of<UserProvider>(context, listen: false).user.username ==
        widget.channelId) {
      await FirestoreMethods().endLiveStream(widget.channelId);
    } else {
      await FirestoreMethods().updateViewCount(widget.channelId, false);
    }
    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  }

  void _switchCamera() {
    _engine
        .switchCamera()
        .then((value) => {
              setState(() {
                switchCamera = !switchCamera;
              })
            })
        .catchError((err) {
      debugPrint('switchCamera $err');
    });
  }

  void onToggleMute() async {
    setState(() {
      isMuted = !isMuted;
    });
    await _engine.muteLocalAudioStream(isMuted);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return WillPopScope(
      onWillPop: () async {
        await _leaveChannel();
        return Future.value(true);
      },
      child: Scaffold(
        bottomNavigationBar: widget.isBroadcaster
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: CustomButton(
                  text: 'End stream',
                  onTap: _leaveChannel,
                ),
              )
            : null,
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ResponsiveLayout(
              desktopBody: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _renderVideo(user),
                        if ("${user.uid}${user.username}" == widget.channelId)
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: _switchCamera,
                                child: const Text('Switch camera'),
                              ),
                              InkWell(
                                onTap: onToggleMute,
                                child: Text(isMuted ? 'Unmute' : 'Mute'),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Chat(channelId: widget.channelId),
                ],
              ),
              mobileBody: Column(
                children: [
                  _renderVideo(user),
                  if ("${user.uid}${user.username}" == widget.channelId)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: _switchCamera,
                          child: const Text('Switch camera'),
                        ),
                        InkWell(
                          onTap: onToggleMute,
                          child: Text(isMuted ? 'Unmute' : 'Mute'),
                        ),
                      ],
                    ),
                  Expanded(
                    child: Chat(
                      channelId: widget.channelId,
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  _renderVideo(user) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: "${user.uid}${user.username}" == widget.channelId
          ? const RtcLocalView.SurfaceView(
              zOrderMediaOverlay: true,
              zOrderOnTop: true,
            )
          : remoteUid.isNotEmpty
              ? kIsWeb
                  ? RtcRemoteView.SurfaceView(
                      uid: remoteUid[0],
                      channelId: widget.channelId,
                    )
                  : RtcRemoteView.TextureView(
                      uid: remoteUid[0],
                      channelId: widget.channelId,
                    )
              : Container(),
    );
  }
}
