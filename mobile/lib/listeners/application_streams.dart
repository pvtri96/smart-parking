import 'dart:async';

import 'package:parking_lots/entity/request.dart';
import 'package:parking_lots/entity/response.dart';

class ApplicationStreams {
  static Request currentRequest;

  static StreamSubscription onRequestChildUpdateSubscription;
  static StreamController<Response> onResponseFindingParkingLot = StreamController();
  static StreamController<String> onMovingBookingToParkingLot = StreamController();

  static closeAllStream() {
    onResponseFindingParkingLot.close();
    onRequestChildUpdateSubscription.cancel();
    onMovingBookingToParkingLot.close();

    onResponseFindingParkingLot = new StreamController();
    onMovingBookingToParkingLot = new StreamController();
  }
}