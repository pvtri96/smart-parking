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
    Location currentLocation = Location(address, lat, lng);
    ApplicationStreams.currentLocation = currentLocation;

    Request requestFindParkingLot = Request(clientId, Status.REQUEST_FIND_PARKING_LOT);
    Payload payload = Payload(location: currentLocation);
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

  Future<Request> driverCheckIn() async{
    Request request = ApplicationStreams.currentRequest;
    request.status = Status.REQUEST_CHECK_IN_PARKING_LOT;

    await _requestRepository.updateRequest(request.id, request.toClientRequestCheckInJson());

    return request;
  }

  Future<Request> securityAllowOrRejectCheckIn(String requestId, String clientId, String status) async {
    Request request = Request(clientId, status);
    request.id = requestId;

    await _requestRepository.updateRequest(
        request.id, request.toSecurityAcceptOrRejectCheckInJson());

    return request;
  }

  Future<Request> clientRequestCheckout() async{
    Request request = ApplicationStreams.currentRequest;
    request.status = Status.REQUEST_CHECK_OUT_PARKING_LOT;

    await _requestRepository.updateRequest(request.id, request.toClientRequestCheckInJson());

    return request;
  }
}