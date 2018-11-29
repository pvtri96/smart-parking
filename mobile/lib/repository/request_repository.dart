import 'package:firebase_database/firebase_database.dart';
import 'package:parking_lots/entity/request.dart';
import 'package:parking_lots/enum/status.dart';
import 'package:parking_lots/listeners/application_streams.dart';

class RequestRepository {
  final DatabaseReference databaseRef =
      FirebaseDatabase.instance.reference().child(Request.COLLECTION_NAME);

  Future<Request> saveAndSubscribeRequest(Request request) async {
    String key = databaseRef.push().key;
    await databaseRef.child(key).set(request.toJson());
    request.id = key;
    
    databaseRef.child(key).onChildChanged.listen((Event event) {
      _handleUpdateEvent(event.snapshot);
    });
    
    return request;
  }

  _handleUpdateEvent(DataSnapshot snapShot) {
    Request request = Request.fromMap(snapShot.value, snapShot.key);

    if (request.status == Status.RESPONSE_FIND_PARKING_LOT) {
      ApplicationStreams.onResponseFindingParkingLot.add(request.response);
    }
  }
}
