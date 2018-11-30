import 'parking_lot.dart';

class Response {
  List<ParkingLot> parkingLots;

  Response({this.parkingLots});

  toJson() {
    return {
      "parkingLots": [
        parkingLots.forEach((parkingLot) {
          parkingLot.toJson();
        })
      ]
    };
  }

  factory Response.fromMap(Map<dynamic, dynamic> data) {
    List<ParkingLot> result = List();
    data.forEach((key, value) {
      result.add(ParkingLot.fromMap(value));
    });

    return Response(
      parkingLots: result
    );
  }
}