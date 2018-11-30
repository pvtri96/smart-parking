import 'dart:async';

import 'package:parking_lots/entity/response.dart';

class ApplicationStreams {
  static StreamSubscription onRequestChildUpdateSubscription;
  static StreamController<Response> onResponseFindingParkingLot = StreamController();
}