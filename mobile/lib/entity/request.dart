import 'payload.dart';
import 'response.dart';

class Request {
  static const String COLLECTION_NAME = 'requests';

  String id;
  String clientId;
  String status;
  Payload payload;
  Response response;

  Request(this.clientId, this.status, {this.id, this.payload, this.response});

  toJson() {
    return {
      "clientId": this.clientId,
      "status": this.status,
      "payload": this.payload != null ? this.payload.toJson() : '',
      "response": this.response != null ? this.response.toJson() : ''
    };
  }

  toRequestBookingJson() {
    return {
      "clientId": this.clientId,
      "status": this.status,
      "payload": this.payload != null ? this.payload.toBookParkingJson() : '',
      "response": this.response != null ? this.response.toJson() : ''
    };
  }

  toClientRequestCheckInJson() {
    return {
      "clientId": this.clientId,
      "status": this.status,
    };
  }

  toSecurityAcceptOrRejectCheckInJson() {
    return {
      "clientId": this.clientId,
      "status": this.status,
    };
  }

  toForbiddenJson() {
    return {
      "clientId": this.clientId,
      "status": this.status,
    };
  }

  factory Request.fromMap(Map<dynamic, dynamic> data, String key) {
    return Request(
      data['clientId'].toString(),
      data['status'].toString(),
      id: key,
      payload: Payload.fromMap(data['payload']),
      response: Response.fromMap(data['response'])
    );
  }
}