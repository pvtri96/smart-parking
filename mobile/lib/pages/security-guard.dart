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

  final List<TabEntity> tabs = [
    TabEntity(title: 'Booking List', icon: Icon(Icons.watch_later)),
    TabEntity(title: 'Parking List', icon: Icon(Icons.album)),
  ];

  TabEntity _tabsHandler;
  TabController _tabController;

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

  Widget _buildParkingDriver(DriverEntity slot) {
    int timeStamp = slot.updatedAt;
    DateTime updatedAt = convertToDate(timeStamp);
    return ListTile(
      leading: Icon(Icons.directions_car),
      title: Text('Client ${slot.clientId}'),
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
                      title:
                          Text('Total slots: ${widget.parkingLots.capacity}'),
                    ),
                    ListTile(
                      leading: Icon(Icons.spa),
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
                ),
                _buildPendingDriversList(),
                _buildParkingDriversList()
              ]),
            )));
  }
}

class TabEntity {
  final String title;
  final Icon icon;

  TabEntity({this.title, this.icon});
}
