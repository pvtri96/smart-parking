import 'package:flutter/material.dart';
import 'package:parking_lots/entity/security-guard.dart';
import 'package:parking_lots/widgets/drawer.dart';

class SecurityGuard extends StatefulWidget {
  static const String route = '/security_guard';
  final SecurityGuardEntity securityGuardEntity;

  SecurityGuard(this.securityGuardEntity);

  @override
  _SecurityGuardState createState() => _SecurityGuardState();
}

class _SecurityGuardState extends State<SecurityGuard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Security Guard: ${widget.securityGuardEntity.name}'),
        ),
        drawer: buildDrawer(context, SecurityGuard.route),
        body: Container(
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.place),
                title: Text('Address: ${widget.securityGuardEntity.address}'),
              ),
              ListTile(
                leading: Icon(Icons.all_inclusive),
                title: Text(
                    'Total slots: ${widget.securityGuardEntity.totalSlots}'),
              ),
              ListTile(
                leading: Icon(Icons.spa),
                title: Text(
                    'Booked slots: ${widget.securityGuardEntity.bookedSlots}'),
              ),
              ListTile(
                leading: Icon(Icons.card_giftcard),
                title: Text(
                    'Waiting slots: ${widget.securityGuardEntity.waitingSlots}'),
              ),
              ListTile(
                leading: Icon(Icons.space_bar),
                title: Text(
                    'Avaiable slots: ${widget.securityGuardEntity.availableSlots}'),
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
        ));
  }
}
