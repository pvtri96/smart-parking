import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:parking_lots/entity/parking-lot.dart';
import 'package:parking_lots/widgets/drawer.dart';

import 'parking_lot.dart';

class ParkingLotMarkers extends StatefulWidget {
  static const String route = '/';
  static const String mapBoxAccessToken =
      'pk.eyJ1IjoiZHVuZ2xlMTgxMSIsImEiOiJjam93b2NrYXIxdG93M3Fsa3J3MXNjMDFlIn0.paMZmOKnCnZU_NBU3qfxtQ';

  final parkingLots = <ParkingLotEntity>[
    ParkingLotEntity(
      name: 'Parking lot 1',
      lat: 16.043658,
      lng: 108.240327,
      totalSlots: 20,
      availableSlots: 2,
    ),
    ParkingLotEntity(
      name: 'Parking lot 2',
      lat: 16.044060,
      lng: 108.239898,
      totalSlots: 20,
      availableSlots: 10,
    ),
    ParkingLotEntity(
      name: 'Parking lot 3',
      lat: 16.036360,
      lng: 108.229392,
      totalSlots: 20,
      availableSlots: 10,
    ),
    ParkingLotEntity(
      name: 'Parking lot 4',
      lat: 16.044596,
      lng: 108.239694,
      totalSlots: 20,
      availableSlots: 7,
    ),
    ParkingLotEntity(
      name: 'Parking lot 5',
      lat: 16.043606,
      lng: 108.244254,
      totalSlots: 20,
      availableSlots: 10,
    )
  ];

  @override
  _ParkingLotMarkersState createState() => _ParkingLotMarkersState();
}

class _ParkingLotMarkersState extends State<ParkingLotMarkers> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  MapController mapController;
  Map<String, double> currentLocation = Map();
  Location location = Location();
  String error;
  LatLngBounds _bounds;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
//    _initPlatformState().then((response) => setState(
//    ));
  }

  _updatePosition() {
    _timer = Timer(const Duration(milliseconds: 2000), () {
      setState(() {
        _bounds = mapController.bounds;
      });
      // TODO: Call API to update parking lots inside the current bounds
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  Future<Map<String, double>> _initPlatformState() async {
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
    return myLocation;
  }

  @override
  Widget build(BuildContext context) {
    var markers = <Marker>[
      Marker(
          width: 35,
          height: 35,
          point: LatLng(widget.parkingLots[0].lat, widget.parkingLots[0].lng),
          builder: (context) => Container(
                child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.red,
                    iconSize: 35,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ParkingLot(widget.parkingLots[0])));
                    }),
              )),
      Marker(
          width: 35,
          height: 35,
          point: LatLng(widget.parkingLots[1].lat, widget.parkingLots[1].lng),
          builder: (context) => Container(
                child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.red,
                    iconSize: 35,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ParkingLot(widget.parkingLots[1])));
                    }),
              )),
      Marker(
          width: 35,
          height: 35,
          point: LatLng(widget.parkingLots[2].lat, widget.parkingLots[2].lng),
          builder: (context) => Container(
                child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.red,
                    iconSize: 35,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ParkingLot(widget.parkingLots[2])));
                    }),
              )),
      Marker(
          width: 35,
          height: 35,
          point: LatLng(widget.parkingLots[3].lat, widget.parkingLots[3].lng),
          builder: (context) => Container(
                child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.red,
                    iconSize: 35,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ParkingLot(widget.parkingLots[3])));
                    }),
              )),
      Marker(
          width: 35,
          height: 35,
          point: LatLng(widget.parkingLots[4].lat, widget.parkingLots[4].lng),
          builder: (context) => Container(
                child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.red,
                    iconSize: 35,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ParkingLot(widget.parkingLots[4])));
                    }),
              )),
      Marker(
          width: 35,
          height: 35,
          point: LatLng(16.041967, 108.241014),
          builder: (context) => Container(
                child: IconButton(
                    icon: Icon(Icons.adjust),
                    color: Colors.blue,
                    iconSize: 35,
                    onPressed: () {}),
              )),
    ];

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Home'),
        ),
        drawer: buildDrawer(context, ParkingLotMarkers.route),
        body: Padding(
          padding: EdgeInsets.all(0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  children: <Widget>[
                    MaterialButton(
                        child: Text('Get Bounds'),
                        onPressed: () {
                          final bounds = mapController.bounds;

                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text('Map bounds: \n'
                                  'NE: ${bounds.northEast} \n'
                                  'SW: ${bounds.southWest}')));
                        })
                  ],
                ),
              ),
              Flexible(
                child: FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                      center: LatLng(16.041926, 108.241036),
                      zoom: 15,
                      onPositionChanged: (position, hasGesture) {
                        _updatePosition();
                      }),
                  layers: [
                    TileLayerOptions(
                      urlTemplate:
                          'https://api.mapbox.com/v4/{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
                      additionalOptions: {
                        'accessToken': ParkingLotMarkers.mapBoxAccessToken,
                        'id': 'mapbox.streets',
                      },
                    ),
                    MarkerLayerOptions(markers: markers)
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
