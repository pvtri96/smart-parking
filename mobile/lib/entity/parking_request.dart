class ParkingRequest {
  String id;
  String clientId;
  String requestId;
  int updatedAt;
  String status;

  ParkingRequest(
      this.clientId,
      this.requestId,
      this.updatedAt,
      this.status
      );

  toJson() {
    return {
      "clientId": this.clientId,
      "requestId": this.requestId,
      "updatedAt": this.updatedAt,
      "status": this.status
    };
  }

  factory ParkingRequest.fromMap(Map<dynamic, dynamic> data) {
    return ParkingRequest(
      data['clientId'],
      data['requestId'],
      data['updatedAt'],
      data['status']
    );
  }
}