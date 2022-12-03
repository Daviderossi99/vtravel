import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:http/http.dart' as http;
import 'package:v_travel/utils/utils.dart';
import 'dart:convert' as convert;
import '../models/livestream.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  LatLng? currentLocation;
  double zoom = 11;

  final LocationSettings locationSettings =
      const LocationSettings(accuracy: LocationAccuracy.high);

  final Set<Marker> markers = {};

  Uint8List myIcon = Uint8List(1);

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void setIcon() {
    getBytesFromAsset('assets/circle-solid.png', 10 * zoom.round())
        .then((value) {
      setState(() {
        myIcon = value;
      });
    });
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Geolocator.getCurrentPosition().then((position) => setState(() {
          currentLocation = LatLng(position.latitude, position.longitude);
        }));

    /*Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) {
      if (position != null) {
        LatLng location = LatLng(position.latitude, position.longitude);
        setState(() {
          currentLocation = location;
        });
      }
    });*/
  }

  String? input;
  List<dynamic> placesList = [];

  bool foundLocation = false;

  void getSuggestion(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&inputtype=textquery&key=$google_api_key';

    var response = await http.get(Uri.parse(url));

    setState(() {
      placesList = jsonDecode(response.body.toString())['predictions'];
    });
  }

  Future<String> getPlaceId(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$google_api_key';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    var placeId = json['candidates'][0]['place_id'] as String;
    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$google_api_key';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    var results = json['result'] as Map<String, dynamic>;

    return results;
  }

  Future<Map<String, dynamic>> getPlaceWithId(String placeId) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$google_api_key';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    var results = json['result'] as Map<String, dynamic>;

    return results;
  }

  Future<void> goToPlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 10)));
    setState(() {
      foundLocation = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    setIcon();
  }

  Set<Marker> updateMarkers(AsyncSnapshot<dynamic> snapshot) {
    snapshot.data.docs.forEach((doc) => {
          markers.add(Marker(
            icon: BitmapDescriptor.fromBytes(myIcon),
            markerId: const MarkerId("currentLocation"),
            position: LatLng(LiveStream.fromMap(doc.data()).latitude,
                LiveStream.fromMap(doc.data()).longitude),
          ))
        });
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      body: currentLocation == null
          ? const Center(
              child: Text("Loading"),
            )
          : Stack(
              fit: StackFit.expand,
              children: [
                StreamBuilder<dynamic>(
                    stream: FirebaseFirestore.instance
                        .collection('livestream')
                        .snapshots(),
                    builder: (context, snapshot) {
                      return GoogleMap(
                        onMapCreated: ((controller) =>
                            _controller.complete(controller)),
                        compassEnabled: false,
                        zoomControlsEnabled: false,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(currentLocation!.latitude,
                              currentLocation!.longitude),
                          zoom: zoom,
                        ),
                        onCameraMove: (position) {
                          setState(() {
                            zoom = position.zoom;
                            setIcon();
                          });
                        },
                        markers: snapshot.data != null &&
                                snapshot.data.docs.length > 0 &&
                                zoom > 10
                            ? updateMarkers(snapshot)
                            : {},
                      );
                    }),
                FloatingSearchBar(
                  onFocusChanged: (isFocused) => setState(() {
                    foundLocation = !isFocused;
                  }),
                  onSubmitted: (query) => foundLocation = true,
                  hint: 'Search...',
                  borderRadius: BorderRadius.circular(20),
                  scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
                  transitionDuration: const Duration(milliseconds: 300),
                  transitionCurve: Curves.easeInOut,
                  physics: const BouncingScrollPhysics(),
                  axisAlignment: isPortrait ? 0.0 : -1.0,
                  openAxisAlignment: 0.0,
                  width: isPortrait ? 600 : 500,
                  debounceDelay: const Duration(milliseconds: 200),
                  onQueryChanged: (query) {
                    getSuggestion(query);
                    setState(() {
                      input = query;
                    });
                  },
                  // Specify a custom transition to be used for
                  // animating between opened and closed stated.
                  transition: SlideFadeFloatingSearchBarTransition(),
                  actions: [
                    FloatingSearchBarAction.back(),
                    FloatingSearchBarAction(
                      showIfOpened: false,
                      showIfClosed: true,
                      child: CircularButton(
                        icon: const Icon(Icons.place),
                        onPressed: () {},
                      ),
                    ),
                    FloatingSearchBarAction(
                      showIfOpened: input != null ? true : false,
                      showIfClosed: false,
                      child: CircularButton(
                        icon: const Icon(Icons.search),
                        onPressed: () async {
                          var place = await getPlace(input!);
                          goToPlace(place);
                        },
                      ),
                    )
                  ],
                  builder: (context, transition) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Material(
                        color: Colors.white,
                        elevation: 4.0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: !foundLocation
                              ? placesList
                                  .map((suggestion) => ListTile(
                                        title: Text(suggestion['description']),
                                        onTap: () async {
                                          var place = await getPlaceWithId(
                                              suggestion['place_id']);
                                          goToPlace(place);
                                        },
                                      ))
                                  .toList()
                              : [],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
