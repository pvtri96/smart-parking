import 'package:flutter/material.dart';
import 'package:parking_lots/pages/home.dart';
import 'package:parking_lots/pages/parking_lot_markers.dart';
import 'package:parking_lots/pages/security-guards.dart';

Drawer buildDrawer(BuildContext context, String currentRoute) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        DrawerHeader(
            child: Center(
          child: MaterialButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, Home.route);
            },
            child: Text('HOME'),
          ),
        )),
        ListTile(
          title: Text('Find parking lots'),
          selected: currentRoute == ParkingLotMarkers.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, ParkingLotMarkers.route);
          },
        ),
        ListTile(
          title: Text('Security guards'),
          selected: currentRoute == SecurityGuards.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, SecurityGuards.route);
          },
        ),
      ],
    ),
  );
}
