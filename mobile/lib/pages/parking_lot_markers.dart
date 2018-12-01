import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:parking_lots/entity/response.dart';
import 'package:parking_lots/listeners/application_streams.dart';
import 'package:parking_lots/pages/parking_lot.dart';
import 'package:parking_lots/services/request_services.dart';
import 'package:parking_lots/widgets/drawer.dart';

class ParkingLotMarkers extends StatefulWidget {
  static const String route = '/parking_lots';
  static const String mapBoxAccessToken =
      'pk.eyJ1IjoiZHVuZ2xlMTgxMSIsImEiOiJjam93b2NrYXIxdG93M3Fsa3J3MXNjMDFlIn0.paMZmOKnCnZU_NBU3qfxtQ';

  @override
  _ParkingLotMarkersState createState() => _ParkingLotMarkersState();
}

class _ParkingLotMarkersState extends State<ParkingLotMarkers>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final RequestService _requestService = RequestService();
  final StreamController<List<Marker>> _markerStream = StreamController();

  MapController mapController;
  Map<String, double> currentLocation = Map();
  Location location = Location();
  String error;
  LatLngBounds _bounds;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _registerStream();
    _initPlatformState().then((location) {
      _requestService
          .findParkingLot('', location['latitude'], location['longitude'])
          .then((request) {
        ApplicationStreams.currentRequest = request;
      });
    });
  }

  _registerStream() {
    ApplicationStreams.onResponseFindingParkingLot.stream
        .listen((Response response) {
      List<Marker> result = List();
      response.parkingLots.forEach((parkingLot) {
        Marker marker = Marker(
            width: 35,
            height: 35,
            point: LatLng(parkingLot.location.lat, parkingLot.location.lng),
            builder: (context) => Container(
                  child: IconButton(
                      icon: Icon(Icons.location_on),
                      color: Colors.red,
                      iconSize: 35,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ParkingLotScreen(parkingLot)));
                      }),
                ));
        result.add(marker);
      });

      _markerStream.add(result);
    });
  }

  _updatePosition() {
    _timer = Timer(const Duration(milliseconds: 2000), () {
      setState(() {
        _bounds = mapController.bounds;
      });
      // TODO: Call API to update parking lots inside the current bounds
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    _markerStream.close();
    ApplicationStreams.onRequestChildUpdateSubscription.cancel();
    ApplicationStreams.onResponseFindingParkingLot.close();
  }

  Future<Map<String, double>> _initPlatformState() async {
    Map<String, double> myLocation;
    try {
      myLocation = await location.getLocation();
      error = '';
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
            'Permission denied. Please ask the user to enable it from the app settings.';
        myLocation = null;
      }
    }
    return myLocation;
  }

  void _animatedMapMove(LatLng desLocation, double desZoom) {
    final _latTween = Tween<double>(
        begin: mapController.center.latitude, end: desLocation.latitude);
    final _lngTween = Tween<double>(
        begin: mapController.center.longitude, end: desLocation.longitude);
    final _zoomTween = Tween<double>(begin: mapController.zoom, end: desZoom);

    AnimationController animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    Animation<double> animation = CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn);

    animationController.addListener(() {
      mapController.move(
          LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.dispose();
      } else if (status == AnimationStatus.dismissed) {
        animationController.dispose();
      }
    });

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Home'),
        ),
        drawer: buildDrawer(context, ParkingLotMarkers.route),
        body: Padding(
          padding: EdgeInsets.all(0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  children: <Widget>[
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                            child: Text('Get bounds'),
                            onPressed: () {
                              final bounds = mapController.bounds;

                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text('Map bounds: \n'
                                      'NE: ${bounds.northEast} \n'
                                      'SW: ${bounds.southWest}')));
                            }),
                        RaisedButton(
                            child: Text('Find parking lots'),
                            onPressed: () {
                              _initPlatformState().then((location) {
                                _requestService
                                    .findParkingLot('', location['latitude'],
                                        location['longitude'],
                                        reFind: true,
                                        requestId: ApplicationStreams
                                            .currentRequest.id)
                                    .then((request) {
                                  ApplicationStreams.currentRequest = request;
                                });
                              });
                            }),
                        RaisedButton(
                            child: Text('My location'),
                            onPressed: () {
                              _animatedMapMove(
                                  LatLng(16.041926, 108.241036), 15);
                            })
                      ],
                    )
                  ],
                ),
              ),
              StreamBuilder(
                stream: _markerStream.stream,
                builder: (context, snapShot) {
                  List<Marker> markers = snapShot.data ?? List();
                  if (markers.isEmpty) {
                    return Flexible(child: CircularProgressIndicator());
                  }
                  return Flexible(
                    child: FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                          center: LatLng(16.041926, 108.241036),
                          zoom: 14,
                          onPositionChanged: (position, hasGesture) {
                            _updatePosition();
                          }),
                      layers: [
                        TileLayerOptions(
                          urlTemplate:
                              'https://api.mapbox.com/v4/{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
                          additionalOptions: {
                            'accessToken': ParkingLotMarkers.mapBoxAccessToken,
                            'id': 'mapbox.streets',
                          },
                        ),
                        MarkerLayerOptions(markers: markers)
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
