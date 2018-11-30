import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:parking_lots/entity/parking_lot.dart';
import 'package:parking_lots/services/request_services.dart';

class ParkingLotScreen extends StatefulWidget {
  final ParkingLot parkingLot;

  ParkingLotScreen(this.parkingLot);

  @override
  _ParkingLotScreenState createState() => _ParkingLotScreenState();
}

class _ParkingLotScreenState extends State<ParkingLotScreen> {
  static const String route = '/parking_lot_info';

  final RequestService _requestService = RequestService();

  void _launchNavigationInGoogleMaps() {
    if (Theme.of(context).platform == TargetPlatform.android) {
      final AndroidIntent intent = AndroidIntent(
          action: 'action_view',
          data:
              "http://maps.google.com/maps?daddr=${widget.parkingLot.location.lat},${widget.parkingLot.location.lng}",
          package: 'com.google.android.apps.maps');
      intent.launch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Parking lot: ${widget.parkingLot.name}'),
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.place),
                title: Text('Address: ${widget.parkingLot.location.address}'),
              ),
              ListTile(
                leading: Icon(Icons.all_inclusive),
                title:
                    Text('Total slots: ${widget.parkingLot.capacity}'),
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
                                        onPressed: () async {
                                          await _requestService.bookParkingLot(widget.parkingLot.id);
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
