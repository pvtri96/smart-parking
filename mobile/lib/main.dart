import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'entity/security-guard.dart';
import 'pages/current_location.dart';
import 'pages/home.dart';
import 'pages/parking_lot_markers.dart';
import 'pages/security-guard.dart';

void main() {
  GoogleMapController.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  SecurityGuardEntity securityGuard = SecurityGuardEntity(
    name: 'Security Guard 1',
    address: 'abc',
    totalSlots: 50,
    bookedSlots: 35,
    waitingSlots: 5,
    availableSlots: 10,
  );

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
        SecurityGuard.route: (context) => SecurityGuard(securityGuard),
        CurrentLocation.route: (context) => CurrentLocation(),
      },
    );
  }
}
