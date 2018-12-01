import 'package:flutter/material.dart';
import 'package:parking_lots/entity/driver.dart';
import 'package:parking_lots/entity/parking_lots.dart';

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

  Widget _buildPendingDriversList() {
    return ListView.builder(itemBuilder: (context, index) {
      if (index.isOdd) {
        return Divider();
      }

      final i = index ~/ 2;
      // TODO: GET MORE ITEM WHEN SCROLLING DOWN
      if (i >= _pendingList.length) {
        return ListTile();
//        _pendingList.addAll(...);
      }
      return _buildPendingDriver(_pendingList[i]);
    });
  }

  Widget _buildPendingDriver(DriverEntity slot) {
    return ListTile(
      leading: Icon(Icons.directions_car),
      title: Text('Client ${slot.clientId}'),
      subtitle: Text('Updated at: ${slot.updatedAt}'),
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
//        _pendingList.addAll(...);
      }
      return _buildParkingDriver(_pendingList[i]);
    });
  }

  Widget _buildParkingDriver(DriverEntity slot) {
    return ListTile(
      leading: Icon(Icons.directions_car),
      title: Text('Client ${slot.clientId}'),
      subtitle: Text('Updated at: ${slot.updatedAt}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Security Guard: ${widget.parkingLots.name}'),
        ),
        body: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                actions: <Widget>[],
                title: TabBar(
                  tabs: [
                    Tab(
                      icon: Icon(Icons.info),
                    ),
                    Tab(
                      icon: Icon(Icons.list),
                    ),
                    Tab(
                      icon: Icon(Icons.print),
                    )
                  ],
                  indicatorColor: Colors.white,
                ),
              ),
              body: TabBarView(children: [
                ListView(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.place),
                      title: Text(
                          'Address: ${widget.parkingLots.location.address}'),
                    ),
                    ListTile(
                      leading: Icon(Icons.all_inclusive),
                      title: Text(
                          'Total slots: ${widget.parkingLots.capacity}'),
                    ),
                    ListTile(
                      leading: Icon(Icons.spa),
                      title: Text(
                          'Booked slots: ${widget.parkingLots.pendingRequest != null ? widget.parkingLots.pendingRequest.length : 0}'),
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
                ),
                _buildPendingDriversList(),
                _buildParkingDriversList()
              ]),
            )));
  }
}
