class BookingPrice {
  static final String COLLECTION_NAME = "bookingPrices";

  int duration;
  price double;
  price6 double;
  price12 double;

  BookingPrice(
    this.duration,
    this.price,
    this.price6,
    this.price12
  )

  factory BookingPrice.fromMap(Map<dynamic, dynamic> data) {
    BookingPrice bookingPrice = BookingPrice(
      data['duration'],
      data['price'],
      data['price6'],
      data['price12'],
    )
  }
}
