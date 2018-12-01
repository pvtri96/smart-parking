import 'package:parking_lots/entity/location.dart';
import 'package:parking_lots/entity/parked_request.dart';
import 'package:parking_lots/entity/parking_request.dart';
import 'package:parking_lots/entity/pending_request.dart';

class ParkingLots {
  static const COLLECTION_NAME = 'parkingLots';

  String id;
  int capacity;
  Location location;
  String name;
  List<PendingRequest> pendingRequest;
  List<ParkingRequest> parkingRequest;
  List<ParkedRequest> parkedRequest;

  ParkingLots(
      this.capacity,
      this.location,
      this.name,
      {
        this.pendingRequest,
        this.parkingRequest,
        this.parkedRequest
      }
    );

  factory ParkingLots.fromMap(Map<dynamic, dynamic> data, String key) {
    ParkingLots parkingLots = ParkingLots(
      data['capacity'],
      Location.fromMap(data['location']),
      data['name']
    );
    if (data['pendingRequests'] != null) {
      List pendingRequest = data['pendingRequests'];
      List<PendingRequest> pendingRequestList = List();
      pendingRequest.forEach((value) {
        pendingRequestList.add(PendingRequest.fromMap(value));
      });
      parkingLots.pendingRequest = pendingRequestList;
    }
    if (data['parkingRequests'] != null) {
      List parkingRequests = data['parkingRequests'];
      List<ParkingRequest> parkingRequestList = List();
      parkingRequests.forEach((value) {
        parkingRequestList.add(ParkingRequest.fromMap(value));
      });
      parkingLots.parkingRequest = parkingRequestList;
    }
    if (data['parkedRequests'] != null) {
      List parkedRequests = data['parkedRequests'];
      List<ParkedRequest> parkedRequestList = List();
      parkedRequests.forEach((value) {
        parkedRequestList.add(ParkedRequest.fromMap(value));
      });
      parkingLots.parkedRequest = parkedRequestList;
    }
    parkingLots.id = key;
    return parkingLots;
  }
}
