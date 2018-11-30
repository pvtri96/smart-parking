import 'package:parking_lots/enum/status.dart';
import 'package:parking_lots/repository/request_repository.dart';
import 'package:parking_lots/entity/location.dart';
import 'package:parking_lots/entity/request.dart';
import 'package:parking_lots/entity/payload.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RequestService {
  final RequestRepository _requestRepository = RequestRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> findParkingLot(String address, double lat, double lng, {bool reFind = false}) async{
    FirebaseUser currentUser = await _auth.signInAnonymously();
    String clientId = currentUser.uid;

    Request requestFindParkingLot = Request(clientId, Status.REQUEST_FIND_PARKING_LOT);
    Payload payload = Payload(location: Location(address, lat, lng));
    requestFindParkingLot.payload = payload;

    if (reFind) {
      requestFindParkingLot = await _requestRepository.updateRequest(requestFindParkingLot);
    } else {
      requestFindParkingLot =
      await _requestRepository.saveAndSubscribeRequest(requestFindParkingLot);
    }
  }
}