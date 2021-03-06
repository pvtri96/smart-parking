import 'dart:async';

import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:parking_lots/entity/parking_lot.dart';
import 'package:parking_lots/enum/status.dart';
import 'package:parking_lots/listeners/application_streams.dart';
import 'package:parking_lots/services/request_services.dart';

class ParkingLotScreen extends StatefulWidget {
  static const String mapBoxAccessToken =
      'pk.eyJ1IjoiZHVuZ2xlMTgxMSIsImEiOiJjam93b2NrYXIxdG93M3Fsa3J3MXNjMDFlIn0.paMZmOKnCnZU_NBU3qfxtQ';
  final ParkingLot parkingLot;

  ParkingLotScreen(this.parkingLot);

  @override
  _ParkingLotScreenState createState() => _ParkingLotScreenState();
}

class _ParkingLotScreenState extends State<ParkingLotScreen> {
  static const String route = '/parking_lot_info';

  final RequestService _requestService = RequestService();

  String requestStatus = ApplicationStreams.currentClientStatus;
  bool _allowRender = true;

  void _launchNavigationInGoogleMaps() {
    final AndroidIntent intent = AndroidIntent(
        action: 'action_view',
        data:
            "http://maps.google.com/maps?daddr=${widget.parkingLot.location.lat},${widget.parkingLot.location.lng}",
        package: 'com.google.android.apps.maps');
    intent.launch();
  }

  @override
  void initState() {
    super.initState();
    if (ApplicationStreams.currentRequest.payload.parkingLotId != null &&
        ApplicationStreams.currentRequest.payload.parkingLotId ==
            widget.parkingLot.id) {
      ApplicationStreams.onMovingBookingToParkingLot
          .add(ApplicationStreams.currentClientStatus);
    } else if (ApplicationStreams.currentClientStatus !=
        Status.RESPONSE_FIND_PARKING_LOT) {
      _allowRender = false;
    }
  }

  List<Widget> _buildActionButtons(String status) {
    if (status == Status.MOVING_TO_PARKING_LOT) {
      return <Widget>[
        RaisedButton.icon(
            onPressed: () {
              _launchNavigationInGoogleMaps();
            },
            icon: Icon(Icons.navigation),
            label: Text('Navigate')),
        RaisedButton.icon(
            onPressed: () async {
              ApplicationStreams.currentRequest =
                  await _requestService.driverCheckIn();
            },
            icon: Icon(Icons.arrow_forward),
            label: Text('Check in')),
      ];
    }

    if (status == Status.REQUEST_CHECK_IN_PARKING_LOT) {
      return <Widget>[
        RaisedButton.icon(
          icon: Icon(Icons.swap_vertical_circle),
          label: Text('Checking'),
          onPressed: null,
        ),
      ];
    }

    if (status == Status.PARKING_IN_PARKING_LOT) {
      return <Widget>[
        RaisedButton.icon(
          icon: Icon(Icons.local_parking),
          label: Text('Check out'),
          onPressed: () async {
            await _requestService.clientRequestCheckout();
          },
        ),
      ];
    }

    if (status == Status.REQUEST_CHECK_OUT_PARKING_LOT) {
      return <Widget>[
        RaisedButton.icon(
          icon: Icon(Icons.swap_vertical_circle),
          label: Text('Waiting'),
          onPressed: null,
        ),
      ];
    }

    return <Widget>[
      RaisedButton.icon(
          icon: Icon(Icons.add),
          label: Text('I want to book here'),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Booking Confirmation'),
                    content: Text(
                        "This parking slot will be kept for you within 30 minutes."
                        "It will be canceled if you don't check in."),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel')),
                      FlatButton(
                          onPressed: () async {
                            await _requestService
                                .bookParkingLot(widget.parkingLot.id);
                            Navigator.of(context).pop();
                          },
                          child: Text('Confirm'))
                    ],
                  );
                });
          })
    ];
  }

  @override
  void dispose() {
    super.dispose();
    ApplicationStreams.onMovingBookingToParkingLot.close();
    ApplicationStreams.onMovingBookingToParkingLot = StreamController();
  }

  @override
  Widget build(BuildContext context) {
    if (_allowRender) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Parking lot: ${widget.parkingLot.name}'),
          ),
          body: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: FlutterMap(
                    options: MapOptions(
                        interactive: false,
                        onTap: null,
                        zoom: 13,
                        maxZoom: 15,
                        center: LatLng(widget.parkingLot.location.lat,
                            widget.parkingLot.location.lng)),
                    layers: [
                      TileLayerOptions(
                        urlTemplate:
                            'https://api.mapbox.com/v4/{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
                        additionalOptions: {
                          'accessToken': ParkingLotScreen.mapBoxAccessToken,
                          'id': 'mapbox.streets',
                        },
                      ),
                      MarkerLayerOptions(markers: <Marker>[
                        Marker(
                            point: LatLng(widget.parkingLot.location.lat,
                                widget.parkingLot.location.lng),
                            builder: (context) => Container(
                                  child: IconButton(
                                      icon: Icon(Icons.location_on),
                                      color: Colors.red,
                                      iconSize: 35,
                                      onPressed: () {}),
                                ))
                      ])
                    ],
                  ),
                ),
                Expanded(
                    child: ListView(children: <Widget>[
                  StreamBuilder(
                    stream:
                        ApplicationStreams.onMovingBookingToParkingLot.stream,
                    builder: (context, snapshot) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                        child: ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: _buildActionButtons(snapshot.data),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text(
                        'Your request ID: ${ApplicationStreams.currentRequest.id}'),
                  ),
                  ListTile(
                    leading: Icon(Icons.place),
                    title:
                        Text('Address: ${widget.parkingLot.location.address}'),
                  ),
                  ListTile(
                    leading: Icon(Icons.directions),
                    title: Text('Distance: ${widget.parkingLot.distance.text}'),
                  ),
                  ListTile(
                    leading: Icon(Icons.directions_car),
                    title: Text('Duration: ${widget.parkingLot.duration.text}'),
                  ),
                  ListTile(
                    leading: Icon(Icons.change_history),
                    title: Text('Total slots: ${widget.parkingLot.capacity}'),
                  ),
                ])),
              ],
            ),
          ));
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text('Parking lot: ${widget.parkingLot.name}'),
          ),
          body: Center(
            child: Text(
                'You are not allow to book here, finish your booking first'),
          ));
    }
  }
}
