class ParkedRequest {
  String id;
  String clientId;
  String requestId;
  int updatedAt;
  String status;

  ParkedRequest(
      this.clientId,
      this.requestId,
      this.updatedAt,
      this.status
      );

  factory ParkedRequest.fromMap(Map<dynamic, dynamic> data) {
    return ParkedRequest(
      data['clientId'],
      data['requestId'],
      data['updatedAt'],
      data['status']
    );
  }
}