import 'location.dart';

class Payload {
  Location location;

  Payload({
    this.location
  });

  toJson() {
    return {
      "location": this.location.toJson()
    };
  }

  factory Payload.fromMap(Map<dynamic, dynamic> data) {
    return Payload(
      location: Location.fromMap(data)
    );
  }
}