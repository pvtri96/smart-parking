import 'package:firebase_database/firebase_database.dart';
import 'package:parking_lots/entity/booking_price.dart';

class BookingPricesRepository {
  final DatabaseReference _bookingPricesRef = FirebaseDatabase.instance.reference().child(BookingPrice.COLLECTION_NAME);

  Future<BookingPrice> getBookingPriceByDuration(int duration) async {
    DataSnapshot snapshot = await _bookingPricesRef.child(duration.toString()).once();
    Map<dynamic, dynamic> data = snapshot.value;
    BookingPrice bookingPrice = BookingPrice.fromMap(data);
    return bookingPrice;
  }
}
