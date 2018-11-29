//AIzaSyB8L-qiCC0pPlz1CnBav1BwcBkpD8oV6c8
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:parking_lots/widgets/drawer.dart';

class CurrentLocation extends StatefulWidget {
  static const String route = '/get_current_location';
  static const String mapBoxAccessToken =
      'pk.eyJ1IjoiZHVuZ2xlMTgxMSIsImEiOiJjam93b2NrYXIxdG93M3Fsa3J3MXNjMDFlIn0.paMZmOKnCnZU_NBU3qfxtQ';

  @override
  CurrentLocationState createState() => CurrentLocationState();
}

class CurrentLocationState extends State<CurrentLocation> {
  Map<String, double> currentLocation = Map();
  Location location = Location();
  String error;

  // get direction
  var isLoading = false;

  @override
  void initState() {
    super.initState();

//    currentLocation['latitude'] = 0.0;
//    currentLocation['longitude'] = 0.0;

    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    var currentLatitude = currentLocation['latitude'];
    var currentLongitude = currentLocation['longitude'];

    var markers = <Marker>[
      Marker(
          width: 80,
          height: 80,
          point: LatLng(currentLatitude, currentLongitude),
          builder: (context) => Container(
                child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.red,
                    iconSize: 45,
                    onPressed: () {}),
              )),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: buildDrawer(context, CurrentLocation.route),
      body: FlutterMap(
        options: MapOptions(
            center: LatLng(currentLatitude, currentLongitude), zoom: 15),
        layers: [
          TileLayerOptions(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c']),
          MarkerLayerOptions(markers: markers)
        ],
      ),
    );
  }

  void initPlatformState() async {
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
    setState(() {
      currentLocation = myLocation;
    });
  }
}
