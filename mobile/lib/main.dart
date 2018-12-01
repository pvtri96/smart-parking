import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'pages/current_location.dart';
import 'pages/home.dart';
import 'pages/parking_lot_markers.dart';
import 'pages/security-guards.dart';

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
      home: Home(),
      routes: <String, WidgetBuilder>{
        ParkingLotMarkers.route: (context) => ParkingLotMarkers(),
        SecurityGuards.route: (context) => SecurityGuards(),
        CurrentLocation.route: (context) => CurrentLocation(),
      },
    );
  }
}
