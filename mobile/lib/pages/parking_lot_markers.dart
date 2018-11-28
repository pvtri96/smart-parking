import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:parking_lots/widgets/drawer.dart';

import 'parking_lot.dart';

class ParkingLotMarkers extends StatelessWidget {
  static const String route = '/markers';
  static const String mapBoxAccessToken =
      'pk.eyJ1IjoiZHVuZ2xlMTgxMSIsImEiOiJjam93b2NrYXIxdG93M3Fsa3J3MXNjMDFlIn0.paMZmOKnCnZU_NBU3qfxtQ';

  @override
  Widget build(BuildContext context) {
    var markers = <Marker>[
      Marker(
          width: 45,
          height: 45,
          point: LatLng(16.043658, 108.240327),
          builder: (context) => Container(
                child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.red,
                    iconSize: 45,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ParkingLot(
                                    title: 'Parking lot 1',
                                    latitude: 16.043658,
                                    longitude: 108.240327,
                                    totalSlots: 20,
                                    availableSlots: 2,
                                  )));
                    }),
              )),
      Marker(
          width: 45,
          height: 45,
          point: LatLng(16.044060, 108.239898),
          builder: (context) => Container(
                child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.red,
                    iconSize: 45,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ParkingLot(
                                    title: 'Parking lot 2',
                                    latitude: 16.044060,
                                    longitude: 108.239898,
                                    totalSlots: 20,
                                    availableSlots: 10,
                                  )));
                    }),
              )),
      Marker(
          width: 45,
          height: 45,
          point: LatLng(16.045060, 108.236357),
          builder: (context) => Container(
                child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.red,
                    iconSize: 45,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ParkingLot(
                                    title: 'Parking lot 3',
                                    latitude: 16.045060,
                                    longitude: 108.236357,
                                    totalSlots: 20,
                                    availableSlots: 9,
                                  )));
                    }),
              )),
      Marker(
          width: 45,
          height: 45,
          point: LatLng(16.044596, 108.239694),
          builder: (context) => Container(
                child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.red,
                    iconSize: 45,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ParkingLot(
                                    title: 'Parking lot 4',
                                    latitude: 16.044596,
                                    longitude: 108.239694,
                                    totalSlots: 20,
                                    availableSlots: 7,
                                  )));
                    }),
              )),
      Marker(
          width: 45,
          height: 45,
          point: LatLng(16.043606, 108.244254),
          builder: (context) => Container(
                child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.red,
                    iconSize: 45,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ParkingLot(
                                    title: 'Parking lot 5',
                                    latitude: 16.043606,
                                    longitude: 108.244254,
                                    totalSlots: 20,
                                    availableSlots: 10,
                                  )));
                    }),
              )),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: buildDrawer(context, route),
      body: FlutterMap(
        options: MapOptions(center: LatLng(16.041926, 108.241036), zoom: 15),
        layers: [
          TileLayerOptions(
            urlTemplate:
                'https://api.mapbox.com/v4/{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
            additionalOptions: {
              'accessToken': mapBoxAccessToken,
              'id': 'mapbox.streets',
            },
          ),
          MarkerLayerOptions(markers: markers)
        ],
      ),
    );
  }
}
