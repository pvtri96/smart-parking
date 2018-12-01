class ParkingLots {
  int id;
  String name;
  double lat;
  double lng;
  String address;
  int totalSlots;
  int bookedSlots;
  int availableSlots;
  int waitingSlots;

  ParkingLots(
      {this.id,
      this.name,
      this.lat,
      this.lng,
      this.address,
      this.totalSlots,
      this.bookedSlots,
      this.availableSlots,
      this.waitingSlots});
}
