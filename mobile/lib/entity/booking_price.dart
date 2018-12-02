class BookingPrice {
  static const String COLLECTION_NAME = "bookingPrices";

  int duration;
  double price;
  double price6;
  double price12;

  BookingPrice(
    this.duration,
    this.price,
    this.price6,
    this.price12
  );

  factory BookingPrice.fromMap(Map<dynamic, dynamic> data) {
    return BookingPrice(
      data['duration'],
      data['price'],
      data['price6'],
      data['price12'],
    );
  }
}
