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
      ParkingLot parkingLot = ParkingLot.fromMap(value);
      parkingLot.id = key;
      result.add(parkingLot);
    });

    return Response(
      parkingLots: result
    );
  }
}