class ParkingLotEntity {
  int id;
  String name;
  double lat;
  double lng;
  String address;
  int totalSlots;
  int availableSlots;

  ParkingLotEntity({
    this.id,
    this.name,
    this.lat,
    this.lng,
    this.address,
    this.totalSlots,
    this.availableSlots,
  });
}
