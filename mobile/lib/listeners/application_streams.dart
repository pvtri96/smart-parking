import 'dart:async';

import 'package:flutter_map/flutter_map.dart';
import 'package:parking_lots/entity/request.dart';
import 'package:parking_lots/entity/response.dart';

class ApplicationStreams {
  static Request currentRequest;

  static StreamSubscription onRequestChildUpdateSubscription;
  static StreamSubscription onParkingLotsChildUpdateSubscription;
  static StreamSubscription onParkingLotsChildAddSubscription;
  static StreamController<Map<String, List>> securityScreen = StreamController();
  static StreamController<Response> onResponseFindingParkingLot = StreamController();
  static StreamController<String> onMovingBookingToParkingLot = StreamController();
  static List<Marker> markers;
  static Map<String, List> securityScreenMap = Map();
  static bool isRegisterMoving = false;
  static bool isRegisterSecurity = false;
  static String currentClientStatus = '';

  static getOnResponseFindingParkingLot() => onResponseFindingParkingLot;
  static getOnMovingBookingToParkingLot() => onMovingBookingToParkingLot;

  static closeAllStream() {
    currentRequest = null;
    onResponseFindingParkingLot.close();
    onRequestChildUpdateSubscription.cancel();
    onMovingBookingToParkingLot.close();

    onResponseFindingParkingLot = new StreamController();
    onMovingBookingToParkingLot = new StreamController();

    isRegisterMoving = false;
    currentClientStatus = '';
  }

  static closeSecurityStream() {
    securityScreenMap = Map();
    onParkingLotsChildAddSubscription.cancel();
    onParkingLotsChildUpdateSubscription.cancel();
    securityScreen.close();
    securityScreen = StreamController();
  }
}