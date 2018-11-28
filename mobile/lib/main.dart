import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'pages/current_location.dart';
import 'pages/parking_lot_markers.dart';
import 'venues.dart';

void main() {
  GoogleMapController.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Venues(),
      routes: <String, WidgetBuilder>{
        CurrentLocation.route: (context) => CurrentLocation(),
        ParkingLotMarkers.route: (context) => ParkingLotMarkers(),
      },
    );
  }
}
