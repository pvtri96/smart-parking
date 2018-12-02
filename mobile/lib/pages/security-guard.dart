import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parking_lots/entity/parked_request.dart';
import 'package:parking_lots/entity/parking_lots.dart';
import 'package:parking_lots/entity/parking_request.dart';
import 'package:parking_lots/entity/pending_request.dart';
import 'package:parking_lots/enum/status.dart';
import 'package:parking_lots/listeners/application_streams.dart';
import 'package:parking_lots/services/parking_lots_service.dart';
import 'package:parking_lots/services/request_services.dart';

class SecurityGuardScreen extends StatefulWidget {
  static const String route = '/security_guard';
  final ParkingLots parkingLots;

  SecurityGuardScreen(this.parkingLots);

  @override
  _SecurityGuardScreenState createState() => _SecurityGuardScreenState();
}

class _SecurityGuardScreenState extends State<SecurityGuardScreen> {
  final RequestService _requestService = RequestService();
  final ParkingLotsService _parkingLotsService = ParkingLotsService();

  List<Tab> _tabs = <Tab>[
    Tab(
      child: Column(
        children: <Widget>[Icon(Icons.info), Text('Information')],
      ),
    ),
    Tab(
      child: Column(
        children: <Widget>[Icon(Icons.watch_later), Text('Booking List')],
      ),
    ),
    Tab(
      child: Column(
        children: <Widget>[Icon(Icons.local_parking), Text('Parking List')],
      ),
    ),
    Tab(
      child: Column(
        children: <Widget>[Icon(Icons.check_circle), Text('Parked List')],
      ),
    )
  ];

  Widget _buildParkedDriversList(List<ParkedRequest> data) {
    if (data != null && data.isNotEmpty) {
      return ListView.builder(itemBuilder: (context, index) {
        if (index.isOdd) {
          return Divider();
        }

        final i = index ~/ 2;
        // TODO: GET MORE ITEM WHEN SCROLLING DOWN
        if (i >= data.length) {
          return ListTile();
        }
        return _buildParkedDriver(data[i]);
      });
    } else {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text('No car is here')],
        ),
      );
    }
  }

  Widget _buildParkedDriver(ParkedRequest slot) {
    int timeStamp = slot.updatedAt;
    DateTime updatedAt = convertToDate(timeStamp);
    return ListTile(
      leading: Icon(Icons.directions_car),
      title: Text('Ticket ${slot.requestId}'),
      subtitle: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 4, bottom: 4),
              child: Text(
                  'Checked in: ${DateFormat('dd/MM/yyyy').format(updatedAt)}'),
            ),
            Text('Checked out: ${DateFormat('dd/MM/yyyy').format(updatedAt)}')
          ],
        ),
      ),
    );
  }

  Widget _buildParkingLotInfo() {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.place),
          title: Text('Address: ${widget.parkingLots.location.address}'),
        ),
        ListTile(
          leading: Icon(Icons.directions_car),
          title: Text('Total slots: ${widget.parkingLots.capacity}'),
        ),
        ListTile(
          leading: Icon(Icons.watch_later),
          title: Text(
              'Booking slots: ${widget.parkingLots.pendingRequest != null ? widget.parkingLots.pendingRequest.length : 0}'),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _parkingLotsService.findAndRegisterById(widget.parkingLots.id);
  }

  @override
  void dispose() {
    super.dispose();
    ApplicationStreams.closeSecurityStream();
  }

  Widget _buildPendingDriversList(List<PendingRequest> data) {
    if (data != null && data.isNotEmpty) {
      return ListView.builder(itemBuilder: (context, index) {
        if (index.isOdd) {
          return Divider();
        }

        final i = index ~/ 2;
        // TODO: GET MORE ITEM WHEN SCROLLING DOWN
        if (i >= data.length) {
          return ListTile();
        }
        return _buildPendingDriver(data[i], i);
      });
    } else {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text('No car is booking')],
        ),
      );
    }
  }

  Widget _buildPendingDriver(PendingRequest slot, int index) {
    int timeStamp = slot.updatedAt;
    DateTime updatedAt = convertToDate(timeStamp);
    if (slot.status == Status.REQUEST_CHECK_IN_PARKING_LOT) {
      return ListTile(
        leading: Icon(Icons.directions_car),
        title: Text('Ticket ${slot.requestId}'),
        subtitle: Text(
            'Last update at: ${DateFormat('HH:mm dd/MM/yyyy').format(
                updatedAt)}'),
        trailing: ButtonBar(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.check_circle),
                color: Color(0xFF2ECC71),
                splashColor: Color(0xFFB5FFC6),
                padding: EdgeInsets.all(4),
                onPressed: () async {
                  await _requestService.securityAllowOrRejectCheckIn(
                      slot.requestId, slot.clientId, Status.ACCEPT_CHECK_IN_PARKING_LOT);
                }),
            IconButton(
                icon: Icon(Icons.cancel),
                color: Color(0xFFE74C3C),
                splashColor: Color(0xFFFC9797),
                onPressed: () async{
                  await _requestService.securityAllowOrRejectCheckIn(
                      slot.requestId, slot.clientId, Status.REJECT_CHECK_IN_PARKING_LOT);
                }),
          ],
        ),
      );
    }
    return ListTile(
      leading: Icon(Icons.directions_car),
      title: Text('Ticket ${slot.requestId}'),
      subtitle: Text(
          'Last update at: ${DateFormat('HH:mm dd/MM/yyyy').format(
              updatedAt)}')
    );
  }

  Widget _buildParkingDriversList(List<ParkingRequest> data) {
    if (data != null && data.isNotEmpty) {
      return ListView.builder(itemBuilder: (context, index) {
        if (index.isOdd) {
          return Divider();
        }

        final i = index ~/ 2;
        // TODO: GET MORE ITEM WHEN SCROLLING DOWN
        if (i >= data.length) {
          return ListTile();
        }
        return _buildParkingDriver(data[i], i);
      });
    } else {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text('No car is parking')],
        ),
      );
    }
  }

  Widget _buildParkingDriver(ParkingRequest slot, int index) {
    int timeStamp = slot.updatedAt;
    DateTime updatedAt = convertToDate(timeStamp);
    if (slot.status == Status.REQUEST_CHECK_OUT_PARKING_LOT) {
      return ListTile(
        leading: Icon(Icons.directions_car),
        title: Text('Ticket ${slot.requestId}'),
        subtitle:
        Text('Updated at: ${DateFormat('dd/MM/yyyy').format(updatedAt)}'),
        trailing: ButtonBar(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.check_circle),
                color: Color(0xFF2ECC71),
                splashColor: Color(0xFFB5FFC6),
                padding: EdgeInsets.all(4),
                onPressed: () async {
                  await _requestService.securityAllowOrRejectCheckIn(
                      slot.requestId, slot.clientId,
                      Status.ACCEPT_CHECK_OUT_PARKING_LOT);
                }),
            IconButton(
                icon: Icon(Icons.cancel),
                color: Color(0xFFE74C3C),
                splashColor: Color(0xFFFC9797),
                onPressed: () async {
                  await _requestService.securityAllowOrRejectCheckIn(
                      slot.requestId, slot.clientId,
                      Status.REJECT_CHECK_OUT_PARKING_LOT);
                }),
          ],
        ),
      );
    }

    return ListTile(
      leading: Icon(Icons.directions_car),
      title: Text('Ticket ${slot.requestId}'),
      subtitle:
      Text('Updated at: ${DateFormat('dd/MM/yyyy').format(updatedAt)}'),
    );
  }

  DateTime convertToDate(int time) {
    return DateTime.fromMillisecondsSinceEpoch(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Parking lot: ${widget.parkingLots.name}'),
          backgroundColor: Colors.orange,
          elevation: 0.0,
        ),
        body: StreamBuilder(
          stream: ApplicationStreams.securityScreen.stream,
          builder: (context, snapshot) {
            List<PendingRequest> pending = List();
            List<ParkingRequest> parking = List();
            List<ParkedRequest> parked = List();

            if (snapshot.hasData && snapshot.data != null) {
              pending = snapshot.data['pendingRequests'];
              parking = snapshot.data['parkingRequests'];
              parked = snapshot.data['parkedRequests'];
            }

            return DefaultTabController(
              length: _tabs.length,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.orange,
                  automaticallyImplyLeading: false,
                  actions: <Widget>[],
                  title: TabBar(
                    isScrollable: true,
                    tabs: _tabs,
                    indicatorColor: Colors.white,
                  ),
                ),
                body: TabBarView(children: [
                  _buildParkingLotInfo(),
                  _buildPendingDriversList(pending),
                  _buildParkingDriversList(parking),
                  _buildParkedDriversList(parked),
                ]),
              ));
        })
    );
  }
}
