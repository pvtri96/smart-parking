import 'package:parking_lots/enum/status.dart';
import 'package:parking_lots/listeners/application_streams.dart';
import 'package:parking_lots/repository/request_repository.dart';
import 'package:parking_lots/entity/location.dart';
import 'package:parking_lots/entity/request.dart';
import 'package:parking_lots/entity/payload.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RequestService {
  final RequestRepository _requestRepository = RequestRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Request> findParkingLot(String address, double lat, double lng, {bool reFind = false, String requestId = ''}) async{
    FirebaseUser currentUser = await _auth.signInAnonymously();
    String clientId = currentUser.uid;

    Request requestFindParkingLot = Request(clientId, Status.REQUEST_FIND_PARKING_LOT);
    Payload payload = Payload(location: Location(address, lat, lng));
    requestFindParkingLot.payload = payload;

    if (reFind) {
      requestFindParkingLot.id = requestId;
      await _requestRepository.updateRequest(requestId, requestFindParkingLot.toJson());
    } else {
      requestFindParkingLot =
      await _requestRepository.saveAndSubscribeRequest(requestFindParkingLot);
    }

    return requestFindParkingLot;
  }

  Future<Request> bookParkingLot(String parkingLotId) async{
    Request request = ApplicationStreams.currentRequest;
    request.status = Status.REQUEST_BOOKING_PARKING_LOT;
    request.payload = Payload(parkingLotId: parkingLotId);

    await _requestRepository.updateRequest(request.id, request.toRequestBookingJson());

    return request;
  }
}