import 'package:flutter/material.dart';
import 'package:parking_lots/pages/current_location.dart';
import 'package:parking_lots/pages/parking_lot_markers.dart';
import 'package:parking_lots/pages/security-guard.dart';
import 'package:parking_lots/venues.dart';

Drawer buildDrawer(BuildContext context, String currentRoute) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        DrawerHeader(
            child: Center(
          child: Text('Activities'),
        )),
        ListTile(
          title: Text('Find nearest parking lots'),
          selected: currentRoute == ParkingLotMarkers.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, ParkingLotMarkers.route);
          },
        ),
        ListTile(
          title: Text('Security guard'),
          selected: currentRoute == SecurityGuard.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, SecurityGuard.route);
          },
        ),
        ListTile(
          title: Text('Current location'),
          selected: currentRoute == CurrentLocation.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, CurrentLocation.route);
          },
        ),
        ListTile(
          title: Text('Venues'),
          selected: currentRoute == Venues.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, Venues.route);
          },
        ),
      ],
    ),
  );
}
