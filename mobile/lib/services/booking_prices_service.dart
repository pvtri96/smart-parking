import 'package:parking_lots/repository/booking_prices_repository.dart';
import 'package:parking_lots/entity/booking_price.dart';

class BookingPricesService {
  final BookingPricesRepository _bookingPricesRepository = BookingPricesRepository();

  Future<BookingPrice> calculatePriceByCheckInAndCheckOutTime(int checkInAt, {int checkOutAt}) async {
    DateTime checkInAtInDateTime = convertToDate(checkInAt);
    DateTime checkOutAtInDateTime;
    if(checkOutAt != null) {
      checkOutAtInDateTime = convertToDate(checkOutAt);
    } else {
      checkOutAtInDateTime = DateTime.now();
    }

    return await _bookingPricesRepository.getBookingPriceByDuration(checkInAtInDateTime.difference(checkOutAtInDateTime).inHours);
  }

  DateTime convertToDate(int time) {
    return DateTime.fromMillisecondsSinceEpoch(time);
  }
}
