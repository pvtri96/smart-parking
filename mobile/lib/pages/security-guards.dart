import 'package:flutter/material.dart';
import 'package:parking_lots/entity/security-guard.dart';
import 'package:parking_lots/pages/security-guard.dart';
import 'package:parking_lots/widgets/drawer.dart';

class SecurityGuards extends StatefulWidget {
  static const String route = '/security_guards';

  @override
  _SecurityGuardsState createState() => _SecurityGuardsState();
}

class _SecurityGuardsState extends State<SecurityGuards> {
  final _securityGuardList = <SecurityGuardEntity>[
    SecurityGuardEntity(
        id: 1,
        name: 'Place 1',
        address: 'Addess 1',
        totalSlots: 10,
        bookedSlots: 2,
        waitingSlots: 3,
        availableSlots: 5),
    SecurityGuardEntity(
        id: 2,
        name: 'Place 2',
        address: 'Addess 2',
        totalSlots: 10,
        bookedSlots: 2,
        waitingSlots: 3,
        availableSlots: 5),
    SecurityGuardEntity(
        id: 3,
        name: 'Place 3',
        address: 'Addess 3',
        totalSlots: 10,
        bookedSlots: 2,
        waitingSlots: 3,
        availableSlots: 5)
  ];

  Widget _buildSecurityGuardList() {
    return ListView.builder(itemBuilder: (context, index) {
      if (index.isOdd) {
        return Divider();
      }

      final i = index ~/ 2;
      // TODO: GET MORE ITEM WHEN SCROLLING DOWN
      if (i >= _securityGuardList.length) {
        return ListTile();
//        _securityGuardList.addAll(...);
      }
      return _buildSecurityGuard(_securityGuardList[i]);
    });
  }

  Widget _buildSecurityGuard(SecurityGuardEntity parkingLot) {
    return ListTile(
      leading: Icon(Icons.local_parking),
      title: Text(parkingLot.name),
      subtitle: Text(parkingLot.address),
      onTap: () {
        // TODO: GO TO DETAIL
        Navigator.of(context).pushNamed(SecurityGuard.route);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Parking lot List'),
        ),
        drawer: buildDrawer(context, SecurityGuards.route),
        body: _buildSecurityGuardList());
  }
}
