import 'location.dart';
import 'duration.dart';
import 'distance.dart';

class ParkingLot {
  String id;
  int capacity;
  String name;
  Location location;
  Duration duration;
  Distance distance;

  ParkingLot(
      this.capacity, this.name, this.location, this.duration, this.distance);

  toJson() {
    return {
      "capacity": this.capacity,
      "name": this.name,
      "location": this.location.toJson(),
      "duration": this.duration.toJson(),
      "distance": this.distance.toJson()
    };
  }

  factory ParkingLot.fromMap(Map<dynamic, dynamic> data) {
    return ParkingLot(
      data['capacity'],
      data['name'],
      Location.fromMap(data['location']),
      Duration.fromMap(data['duration']),
      Distance.fromMap(data['distance'])
    );
  }
}
