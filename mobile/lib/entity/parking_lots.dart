import 'package:parking_lots/entity/location.dart';
import 'package:parking_lots/entity/pending_request.dart';

class ParkingLots {
  static const COLLECTION_NAME = 'parkingLots';

  String id;
  int capacity;
  Location location;
  String name;
  List<PendingRequest> pendingRequest;

  ParkingLots(
      this.capacity,
      this.location,
      this.name,
      {this.pendingRequest}
      );

  factory ParkingLots.fromMap(Map<dynamic, dynamic> data, String key) {
    ParkingLots parkingLots = ParkingLots(
      data['capacity'],
      Location.fromMap(data['location']),
      data['name']
    );
    if (data['pendingRequest'] != null) {
      List pendingRequest = data['pendingRequest'];
      List<PendingRequest> pendingRequestList = List();
      pendingRequest.forEach((value) {
        pendingRequestList.add(PendingRequest.fromMap(value));
      });
      parkingLots.pendingRequest = pendingRequestList;
    }
    parkingLots.id = key;
    return parkingLots;
  }
}
