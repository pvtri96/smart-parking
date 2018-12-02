import 'package:parking_lots/repository/booking_prices_repository.dart';
import 'package:parking_lots/entity/booking_prices.dart';

class BookingPricesService {
  final BookingPricesRepository _bookingPricesRepository = BookingPricesRepository();

  Future<double> calculatePriceByCheckInAndCheckOutTime(checkInAt int, checkOutAt) {
    DateTime checkInAtInDateTime = convertToDate(checkInAt);
    DateTime checkOutAtInDateTime = convertToDate(checkOutAt);
    return checkInAtInDateTime.difference(checkOutAtInDateTime).inHours;
  }

  DateTime convertToDate(int time) {
    return DateTime.fromMillisecondsSinceEpoch(time);
  }
}
