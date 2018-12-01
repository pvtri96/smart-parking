import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:parking_lots/entity/parking_lot.dart';
import 'package:parking_lots/enum/status.dart';
import 'package:parking_lots/listeners/application_streams.dart';
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

  String requestStatus;

  void _launchNavigationInGoogleMaps() {

      final AndroidIntent intent = AndroidIntent(
          action: 'action_view',
          data:
              "http://maps.google.com/maps?daddr=${widget.parkingLot.location.lat},${widget.parkingLot.location.lng}",
          package: 'com.google.android.apps.maps');
      intent.launch();

  }

  List<Widget> _buildActionButtons() {
    if (requestStatus == Status.MOVING_TO_PARKING_LOT) {
      return <Widget>[
        RaisedButton.icon(
            onPressed: () {
              _launchNavigationInGoogleMaps();
            },
            icon: Icon(Icons.navigation),
            label: Text('Navigate')),
        RaisedButton.icon(
            onPressed: () async{
              ApplicationStreams.currentRequest = await _requestService.driverCheckIn();
            },
            icon: Icon(Icons.arrow_forward),
            label: Text('Check in')),
      ];
    }

    if (requestStatus == Status.REQUEST_CHECK_IN_PARKING_LOT) {
      return <Widget>[
        RaisedButton.icon(
            icon: Icon(Icons.swap_vertical_circle),
            label: Text('Checking')),
      ];
    }

    if (requestStatus == Status.PARKING_IN_PARKING_LOT) {
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

    if (requestStatus == Status.REQUEST_CHECK_OUT_PARKING_LOT) {
      return <Widget>[
        RaisedButton.icon(
            icon: Icon(Icons.swap_vertical_circle),
            label: Text('Waiting')),
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
  void initState() {
    super.initState();
    if (ApplicationStreams.currentRequest != null && !ApplicationStreams.isRegisterMoving) {
      ApplicationStreams.onMovingBookingToParkingLot.stream.listen((status) {
        if (status == Status.MOVING_TO_PARKING_LOT) {
          _launchNavigationInGoogleMaps();
        }
        setState(() {
          requestStatus = status;
        });
      });
      ApplicationStreams.isRegisterMoving = true;
    } else {
      setState(() {
        requestStatus = ApplicationStreams.currentClientStatus;
      });
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
                leading: Icon(Icons.directions_car),
                title: Text('Total slots: ${widget.parkingLot.capacity}'),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text(
                    'Your request ID: ${ApplicationStreams.currentRequest.id}'),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8, left: 8, right: 8),
                child: ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: _buildActionButtons(),
                ),
              )
            ],
          ),
        ));
  }
}
