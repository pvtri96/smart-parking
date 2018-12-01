class PendingRequest {
  String id;
  String clientId;
  String requestId;
  int updatedAt;
  String status;

  PendingRequest(
      this.clientId,
      this.requestId,
      this.updatedAt,
      this.status
      );

  factory PendingRequest.fromMap(Map<dynamic, dynamic> data) {
    return PendingRequest(
      data['clientId'],
      data['requestId'],
      data['updatedAt'],
      data['status']
    );
  }
}