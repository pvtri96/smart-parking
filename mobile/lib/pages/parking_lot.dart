import 'package:flutter/material.dart';
import 'package:parking_lots/widgets/drawer.dart';

class ParkingLot extends StatelessWidget {
  ParkingLot(
      {Key key,
      this.title,
      this.latitude,
      this.longitude,
      this.totalSlots,
      this.availableSlots})
      : super(key: key);

  final String title;
  final double latitude;
  final double longitude;
  final int totalSlots;
  final int availableSlots;

  static const String route = '/get_parking_lot_info';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Parking lot: $title'),
        ),
        drawer: buildDrawer(context, route),
        body: Container(
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text(title),
              ),
              ListTile(
                title: Text('Latitude: $latitude'),
              ),
              ListTile(
                title: Text('Longitude: $longitude'),
              ),
              ListTile(
                title: Text('Total slots: $totalSlots'),
              ),
              ListTile(
                title: Text('Avaiable slots: $availableSlots'),
              ),
              RaisedButton(
                  child: IconButton(
                      icon: Icon(Icons.directions_car), onPressed: () {}),
                  onPressed: () {})
            ],
          ),
        ));
  }
}
