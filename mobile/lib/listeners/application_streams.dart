import 'dart:async';

import 'package:flutter_map/flutter_map.dart';
import 'package:parking_lots/entity/request.dart';
import 'package:parking_lots/entity/response.dart';

class ApplicationStreams {
  static Request currentRequest;

  static StreamSubscription onRequestChildUpdateSubscription;
  static StreamController<Response> onResponseFindingParkingLot = StreamController();
  static StreamController<String> onMovingBookingToParkingLot = StreamController();
  static List<Marker> markers;
  static bool isRegisterMoving = false;
  static String currentClientStatus = '';

  static getOnResponseFindingParkingLot() => onResponseFindingParkingLot;
  static getOnMovingBookingToParkingLot() => onMovingBookingToParkingLot;

  static closeAllStream() {
    onResponseFindingParkingLot.close();
    onRequestChildUpdateSubscription.cancel();
    onMovingBookingToParkingLot.close();

    onResponseFindingParkingLot = new StreamController();
    onMovingBookingToParkingLot = new StreamController();

    isRegisterMoving = false;
    currentClientStatus = '';
  }
}