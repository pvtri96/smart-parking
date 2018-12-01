import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parking_lots/entity/driver.dart';
import 'package:parking_lots/entity/parking_lots.dart';
import 'package:parking_lots/entity/pending_request.dart';

class SecurityGuardScreen extends StatefulWidget {
  static const String route = '/security_guard';
  final ParkingLots parkingLots;

  SecurityGuardScreen(this.parkingLots);

  @override
  _SecurityGuardScreenState createState() => _SecurityGuardScreenState();
}

class _SecurityGuardScreenState extends State<SecurityGuardScreen> {
  final _pendingList = <DriverEntity>[
    DriverEntity(id: 1, clientId: '1', updatedAt: 1),
    DriverEntity(id: 2, clientId: '2', updatedAt: 2),
    DriverEntity(id: 3, clientId: '3', updatedAt: 3),
    DriverEntity(id: 4, clientId: '4', updatedAt: 4),
    DriverEntity(id: 6, clientId: '6', updatedAt: 6),
    DriverEntity(id: 7, clientId: '7', updatedAt: 7),
    DriverEntity(id: 8, clientId: '8', updatedAt: 8),
    DriverEntity(id: 9, clientId: '9', updatedAt: 9),
    DriverEntity(id: 10, clientId: '10', updatedAt: 10)
  ];
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

  Widget _buildPendingDriversList() {
    List<PendingRequest> data = widget.parkingLots.pendingRequest;
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
        return _buildPendingDriver(data[i]);
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

  Widget _buildPendingDriver(PendingRequest slot) {
    int timeStamp = slot.updatedAt;
    DateTime updatedAt = convertToDate(timeStamp);
    return ListTile(
      leading: Icon(Icons.directions_car),
      title: Text('Client ${slot.clientId}'),
      subtitle: Text(
          'Last update at: ${DateFormat('HH:mm dd/MM/yyyy').format(updatedAt)}'),
      trailing: ButtonBar(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.check_circle),
              color: Color(0xFF2ECC71),
              splashColor: Color(0xFFB5FFC6),
              padding: EdgeInsets.all(4),
              onPressed: () {
                // TODO: ACCEPT REQUEST
              }),
          IconButton(
              icon: Icon(Icons.cancel),
              color: Color(0xFFE74C3C),
              splashColor: Color(0xFFFC9797),
              onPressed: () {
                // TODO: REJECT REQUEST
              }),
        ],
      ),
    );
  }

  Widget _buildParkingDriversList() {
    return ListView.builder(itemBuilder: (context, index) {
      if (index.isOdd) {
        return Divider();
      }

      final i = index ~/ 2;
      // TODO: GET MORE ITEM WHEN SCROLLING DOWN
      if (i >= _pendingList.length) {
        return ListTile();
      }
      return _buildParkingDriver(_pendingList[i]);
    });
  }

  Widget _buildParkedDriversList() {
    return ListView.builder(itemBuilder: (context, index) {
      if (index.isOdd) {
        return Divider();
      }

      final i = index ~/ 2;
      // TODO: GET MORE ITEM WHEN SCROLLING DOWN
      if (i >= _pendingList.length) {
        return ListTile();
      }
      return _buildParkedDriver(_pendingList[i]);
    });
  }

  Widget _buildParkingDriver(DriverEntity slot) {
    int timeStamp = slot.updatedAt;
    DateTime updatedAt = convertToDate(timeStamp);
    return ListTile(
      leading: Icon(Icons.directions_car),
      title: Text('Client ${slot.clientId}'),
      subtitle:
          Text('Checked in: ${DateFormat('dd/MM/yyyy').format(updatedAt)}'),
    );
  }

  Widget _buildParkedDriver(DriverEntity slot) {
    int timeStamp = slot.updatedAt;
    DateTime updatedAt = convertToDate(timeStamp);
    return ListTile(
      leading: Icon(Icons.directions_car),
      title: Text('Client ${slot.clientId}'),
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
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 8, left: 8, right: 8),
          child: ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton.icon(
                  icon: Icon(Icons.arrow_forward),
                  label: Text('Check in'),
                  onPressed: () {
                    // TODO: CHECK IN
                  }),
              RaisedButton.icon(
                  icon: Icon(Icons.arrow_back),
                  label: Text('Check out'),
                  onPressed: () {
                    // TODO: CHECK OUT
                  })
            ],
          ),
        )
      ],
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
        ),
        body: DefaultTabController(
            length: _tabs.length,
            child: Scaffold(
              appBar: AppBar(
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
                _buildPendingDriversList(),
                _buildParkingDriversList(),
                _buildParkedDriversList()
              ]),
            )));
  }
}
