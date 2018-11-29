import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  static const String route = '/';
  static const String mapBoxAccessToken =
      'pk.eyJ1IjoiZHVuZ2xlMTgxMSIsImEiOiJjam93b2NrYXIxdG93M3Fsa3J3MXNjMDFlIn0.paMZmOKnCnZU_NBU3qfxtQ';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Choose a role to access to the application'),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                    child: Text('Security Guard'),
                    onPressed: () {
                      // TODO: ACCESS TO THE APPLICATION WITH SECURITY GUARD
                    }),
                RaisedButton(
                    child: Text('Driver'),
                    onPressed: () {
                      // TODO: ACCESS TO THE APPLICATION WITH DRIVER
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
