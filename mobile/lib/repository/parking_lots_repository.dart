import 'package:firebase_database/firebase_database.dart';
import 'package:parking_lots/entity/parked_request.dart';
import 'package:parking_lots/entity/parking_lots.dart';
import 'package:parking_lots/entity/parking_request.dart';
import 'package:parking_lots/entity/pending_request.dart';
import 'package:parking_lots/listeners/application_streams.dart';

class ParkingLotsRepository {
  final DatabaseReference _parkingLotsRef = FirebaseDatabase.instance.reference().child(ParkingLots.COLLECTION_NAME);

  Future<List<ParkingLots>> getAllParkingLot() async{
    List<ParkingLots> result = List();
    DataSnapshot snapshot = await _parkingLotsRef.once();
    Map<dynamic, dynamic> data = snapshot.value;
    data.forEach((key, value) {
      ParkingLots parkingLots = ParkingLots.fromMap(value, key);
      result.add(parkingLots);
    });

    return result;
  }

  Future<void> getParkingLotsById(String id) async {
    ApplicationStreams.onParkingLotsChildUpdateSubscription = _parkingLotsRef.child(id).onChildChanged.listen((event) {
      _handleData(event);
      ApplicationStreams.securityScreen.add(ApplicationStreams.securityScreenMap);
    });
    ApplicationStreams.onParkingLotsChildAddSubscription = _parkingLotsRef.child(id).onChildAdded.listen((event) {
      _handleData(event);
      ApplicationStreams.securityScreen.add(ApplicationStreams.securityScreenMap);
    });
    ApplicationStreams.onParkingLotsChildRemovedSubscription = _parkingLotsRef.child(id).onChildRemoved.listen((event) {
      String key = event.snapshot.key;
      switch (key) {
        case 'pendingRequests': {ApplicationStreams.securityScreenMap[key] = List<PendingRequest>();} break;
        case 'parkingRequests': {ApplicationStreams.securityScreenMap[key] = List<ParkingRequest>();} break;
        case 'parkedRequests': {ApplicationStreams.securityScreenMap[key] = List<ParkedRequest>();} break;
      }
      ApplicationStreams.securityScreen.add(ApplicationStreams.securityScreenMap);
    });
  }

  _handleData(Event event) {
    DataSnapshot snapshot = event.snapshot;
    String key = snapshot.key;
    if (key == 'pendingRequests') {
      List pendingRequests = snapshot.value;
      List<PendingRequest> result = List();
      pendingRequests.forEach((value) {
        result.add(PendingRequest.fromMap(value));
      });
      ApplicationStreams.securityScreenMap['pendingRequests'] = result;
    }
    if (key == 'parkingRequests') {
      List parkingRequests = snapshot.value;
      List<ParkingRequest> result = List();
      parkingRequests.forEach((value) {
        result.add(ParkingRequest.fromMap(value));
      });
      ApplicationStreams.securityScreenMap['parkingRequests'] = result;
    }
    if (key == 'parkedRequests') {
      List parkedRequests = snapshot.value;
      List<ParkedRequest> result = List();
      parkedRequests.forEach((value) {
        result.add(ParkedRequest.fromMap(value));
      });
      ApplicationStreams.securityScreenMap['parkedRequests'] = result;
    }
  }
}