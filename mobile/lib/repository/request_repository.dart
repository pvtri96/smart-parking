import 'package:firebase_database/firebase_database.dart';
import 'package:parking_lots/entity/request.dart';
import 'package:parking_lots/entity/response.dart';
import 'package:parking_lots/enum/status.dart';
import 'package:parking_lots/listeners/application_streams.dart';

class RequestRepository {
  final DatabaseReference databaseRef =
      FirebaseDatabase.instance.reference().child(Request.COLLECTION_NAME);

  Response _response;
  String currentStatus;

  Future<Request> saveAndSubscribeRequest(Request request) async {
    String key = databaseRef.push().key;
    await databaseRef.child(key).set(request.toJson());
    request.id = key;
    currentStatus = request.status;
    
    ApplicationStreams.onRequestChildUpdateSubscription = databaseRef.child(key).onChildChanged.listen((Event event) {
      _handleUpdateEvent(event.snapshot);
    });
    
    return request;
  }

  Future<void> updateRequest(String id, Map<dynamic, dynamic> updateData) async{
    await databaseRef.child(id).update(updateData);
  }

  _handleUpdateEvent(DataSnapshot snapShot) {
    String key = snapShot.key;

    if (key == 'response') {
      if (currentStatus == Status.REQUEST_FIND_PARKING_LOT) {
        if (snapShot.value != '') {
          List parkingLots = snapShot.value['parkingLots'];
          Map<dynamic, dynamic> parkingLotsMap = Map();
          parkingLots.forEach((map) {
            parkingLotsMap[map['id']] = map;
          });
          _response = Response.fromMap(parkingLotsMap);
        }
      }
    }

    if (key == 'status') {
      String status = snapShot.value;
      if (status == Status.RESPONSE_FIND_PARKING_LOT) {
        ApplicationStreams.getOnResponseFindingParkingLot().add(_response);
      }
      if (status == Status.MOVING_TO_PARKING_LOT || status == Status.PARKING_IN_PARKING_LOT || status == Status.REQUEST_CHECK_IN_PARKING_LOT || status == Status.REQUEST_CHECK_OUT_PARKING_LOT) {
        ApplicationStreams.getOnMovingBookingToParkingLot().add(status);
      }
      if (status == Status.ACCEPT_CHECK_OUT_PARKING_LOT) {
        ApplicationStreams.getOnMovingBookingToParkingLot().add(status);

      }
      ApplicationStreams.currentClientStatus = status;
    }
  }
}
