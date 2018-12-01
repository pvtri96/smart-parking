import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parking_lots/entity/parking_lots.dart';
import 'package:parking_lots/pages/security-guard.dart';
import 'package:parking_lots/services/parking_lots_service.dart';
import 'package:parking_lots/widgets/drawer.dart';

class SecurityGuards extends StatefulWidget {
  static const String route = '/security_guards';

  @override
  _SecurityGuardsState createState() => _SecurityGuardsState();
}

class _SecurityGuardsState extends State<SecurityGuards> {
  final ParkingLotsService _parkingLotsService = ParkingLotsService();
  final StreamController<List<ParkingLots>> _parkingLotsStream =
      StreamController();

  Widget _buildSecurityGuardList(List<ParkingLots> data) {
    return ListView.builder(itemBuilder: (context, index) {
      if (index.isOdd) {
        return Divider();
      }

      final i = index ~/ 2;
      // TODO: GET MORE ITEM WHEN SCROLLING DOWN
      if (i >= data.length) {
        return ListTile();
      }
      return _buildSecurityGuard(data[index]);
    });
  }

  Widget _buildSecurityGuard(ParkingLots parkingLot) {
    return ListTile(
      leading: Icon(Icons.local_parking),
      title: Text(parkingLot.name),
      subtitle: Text(parkingLot.location.address),
      onTap: () {
        // TODO: GO TO DETAIL
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SecurityGuardScreen(parkingLot)),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _parkingLotsService.getAll().then((parkingLots) {
      _parkingLotsStream.add(parkingLots);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _parkingLotsStream.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Parking lot List'),
        ),
        drawer: buildDrawer(context, SecurityGuards.route),
        body: StreamBuilder(
            stream: _parkingLotsStream.stream,
            builder: (context, snapShot) {
              List<ParkingLots> data = snapShot.data ?? List();
              if (data.isEmpty) {
                return CircularProgressIndicator();
              }
              return _buildSecurityGuardList(data);
            }));
  }
}
