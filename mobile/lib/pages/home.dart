import 'package:flutter/material.dart';
import 'package:parking_lots/pages/parking_lot_markers.dart';
import 'package:parking_lots/pages/security-guards.dart';

class Home extends StatefulWidget {
  static const String route = '/';
  static const String mapBoxAccessToken =
      'pk.eyJ1IjoiZHVuZ2xlMTgxMSIsImEiOiJjam93b2NrYXIxdG93M3Fsa3J3MXNjMDFlIn0.paMZmOKnCnZU_NBU3qfxtQ';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Choose a role to access to the application'),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
//                Column(
//                  mainAxisSize: MainAxisSize.min,
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Image.asset(
//                      'images/icons/security-guard.png',
//                      height: 24,
//                      width: 24,
//                    ),
//                    Container(
//                      padding: EdgeInsets.only(top: 8),
//                      child: Text('Security Guard'),
//                    ),
//                  ],
//                ),
                RaisedButton.icon(
                    icon: Image.asset(
                      'images/icons/security-guard.png',
                      width: 30,
                      height: 30,
                    ),
                    label: Text('Security Guard'),
                    highlightColor: Color(0xFFB5FFF7),
                    onPressed: () {
                      Navigator.of(context).pushNamed(SecurityGuards.route);
                    }),
                RaisedButton(
                    child: Text('Driver'),
                    onPressed: () {
                      Navigator.of(context).pushNamed(ParkingLotMarkers.route);
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
