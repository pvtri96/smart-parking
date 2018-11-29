import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:parking_lots/entity/parking-lot.dart';

class ParkingLot extends StatefulWidget {
  final ParkingLotEntity parkingLotEntity;

  ParkingLot(this.parkingLotEntity);

  @override
  _ParkingLotState createState() => _ParkingLotState();
}

class _ParkingLotState extends State<ParkingLot> {
  static const String route = '/parking_lot_info';

  void _launchNavigationInGoogleMaps() {
    if (Theme.of(context).platform == TargetPlatform.android) {
      final AndroidIntent intent = AndroidIntent(
          action: 'action_view',
          data:
              "http://maps.google.com/maps?daddr=${widget.parkingLotEntity.lat},${widget.parkingLotEntity.lng}",
          package: 'com.google.android.apps.maps');
      intent.launch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Parking lot: ${widget.parkingLotEntity.name}'),
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.place),
                title: Text('Address: ${widget.parkingLotEntity.address}'),
              ),
              ListTile(
                leading: Icon(Icons.all_inclusive),
                title:
                    Text('Total slots: ${widget.parkingLotEntity.totalSlots}'),
              ),
              ListTile(
                leading: Icon(Icons.space_bar),
                title: Text(
                    'Avaiable slots: ${widget.parkingLotEntity.availableSlots}'),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8, left: 8, right: 8),
                child: ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton.icon(
                        icon: Icon(Icons.navigation),
                        label: Text('Navigate'),
                        onPressed: () {
                          _launchNavigationInGoogleMaps();
                        }),
                    RaisedButton.icon(
                        icon: Icon(Icons.add),
                        label: Text('I want to park here'),
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
                                        onPressed: () {
                                          // TODO: CONFIRM BOOKING
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Confirm'))
                                  ],
                                );
                              });
                        })
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
