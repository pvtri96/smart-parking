class Location {
  String address;
  double lat;
  double lng;

  Location(
      this.address,
      this.lat,
      this.lng
  );

  toJson() {
    return {
      "address": this.address,
      "lat": this.lat,
      "lng": this.lng
    };
  }

  factory Location.fromMap(Map<dynamic, dynamic> data) {
    return Location(
      data['address'].toString(),
      double.parse(data['lat'].toString()),
      double.parse(data['lng'].toString())
    );
  }
}