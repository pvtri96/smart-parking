import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:parking_lots/widgets/drawer.dart';

import 'customized-location.dart';
import 'venue_details.dart';

class Venues extends StatelessWidget {
  static const String route = '/venues';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sydney")),
      drawer: buildDrawer(context, route),
      body: GoogleMaps(),
    );
  }
}

class GoogleMaps extends StatefulWidget {
  GoogleMaps({Key key}) : super(key: key);

  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  CameraPosition _position;
  GoogleMapOptions _options;
  bool _isMoving;
  GoogleMapOverlayController mapOverlayController;
  List<CustomizedLocation> locations = List<CustomizedLocation>();

  Map<String, double> currentLocation = Map();
  Location location = Location();
  String error;

  @override
  void didUpdateWidget(GoogleMaps oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    mapOverlayController.overlayController.deactivateOverlay();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void initState() {
    locations.add(CustomizedLocation(
        id: 1,
        name: 'Parking lot 1',
        address1: 'Bennelong Point',
        address2: 'Sydney NSW 2000, Australia',
        lat: 16.043658,
        lng: 108.240327,
        imageUrl:
            'https://www.planetware.com/photos-large/AUS/australia-sydney-opera-house-2.jpg'));
    locations.add(CustomizedLocation(
        id: 2,
        name: 'Parking lot 2',
        address1: '',
        address2: 'Sydney NSW, Australia',
        lat: 16.044060,
        lng: 108.239898,
        imageUrl:
            'https://www.planetware.com/photos-large/AUS/australia-sydney-harbour-bridge.jpg'));
    locations.add(CustomizedLocation(
        id: 3,
        name: 'Parking lot 3',
        address1: '',
        address2: 'NSW 2000, New York',
        lat: 16.045060,
        lng: 108.236357,
        imageUrl:
            'https://www.planetware.com/photos-large/AUS/australia-sydney-opera-house-2.jpg'));
    locations.add(CustomizedLocation(
        id: 4,
        name: 'Parking lot 4',
        address1: '',
        address2: 'NSW, France',
        lat: 16.044596,
        lng: 108.239694,
        imageUrl:
            'https://www.planetware.com/photos-large/AUS/australia-sydney-harbour-bridge.jpg'));
    super.initState();

    _initPlatformState();
  }

  void buildMap() async {
    if (mapOverlayController != null) return;

    var mq = MediaQuery.of(context);
    // add delay so overlay is positioned correctly
    await Future<Null>.delayed(Duration(milliseconds: 20));

    mapOverlayController = GoogleMapOverlayController.fromSize(
      width: mq.size.width,
      height: mq.size.height,
      options: GoogleMapOptions(
        cameraPosition: CameraPosition(
          target: LatLng(locations[0].lat, locations[0].lng),
          zoom: 15.0,
        ),
        trackCameraPosition: true,
      ),
    );

    locations.forEach((loc) {
      mapOverlayController.mapController.addMarker(MarkerOptions(
          icon: currentLocation != null
              ? BitmapDescriptor.defaultMarker
              : BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueOrange),
          zIndex: loc.id.toDouble(),
          position: LatLng(loc.lat, loc.lng),
          infoWindowText:
              InfoWindowText(loc.name, loc.address1 + ', ' + loc.address2)));
    });

    mapOverlayController.mapController.onInfoWindowTapped.add((Marker marker) {
      mapOverlayController.overlayController.deactivateOverlay();
      var index = marker.options.zIndex.toInt() - 1;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              VenueDetails(locations[index], _notifyPop)));
    });

    mapOverlayController.overlayController.activateOverlay();
    setState(() {});
  }

  Widget renderMap() {
    if (mapOverlayController == null) {
      return Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            SizedBox(
              height: 150.0,
              width: 150.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                value: null,
                strokeWidth: 7.0,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 25.0),
              child: Center(
                child: Text(
                  "Loading.. please wait...",
                ),
              ),
            ),
          ]));
    } else {
      return GoogleMapOverlay(controller: mapOverlayController);
    }
  }

  @override
  Widget build(BuildContext context) {
//    if (currentLocation != null) {
//      final currentLatitude = currentLocation['latitude'];
//      final currentLongitude = currentLocation['longitude'];
//      print('CURRENT LOCATION: $currentLocation');
//
//      locations.add(CustomizedLocation(
//          id: locations.length + 1,
//          name: 'Your location',
//          address1: 'Address ${locations.length + 1}',
//          address2: '',
//          lat: currentLatitude,
//          lng: currentLongitude,
//          imageUrl: ''));
//      print('******* LENGTH: ${locations.length}');
//      buildMap();
//    }
    buildMap();
    return renderMap();
  }

  void _notifyPop(bool success) {
    mapOverlayController.overlayController.activateOverlay();
  }

  void _initPlatformState() async {
    Map<String, double> myLocation;
    try {
      myLocation = await location.getLocation();
      error = '';
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
            'Permission denied. Please ask the user to enable it from the app settings.';
        myLocation = null;
      }
    }
//    print('--------- INIT: $myLocation}');
    currentLocation = myLocation;
    setState(() {
      currentLocation = myLocation;
    });
  }
}
