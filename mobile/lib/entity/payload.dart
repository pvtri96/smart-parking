import 'location.dart';

class Payload {
  Location location;
  String parkingLotId;

  Payload({
    this.location,
    this.parkingLotId
  });

  toJson() {
    return {
      "location": this.location.toJson()
    };
  }

  toBookParkingJson() {
    return {
      "parkingLotId": this.parkingLotId
    };
  }

  factory Payload.fromMap(Map<dynamic, dynamic> data) {
    return Payload(
      location: Location.fromMap(data)
    );
  }
}