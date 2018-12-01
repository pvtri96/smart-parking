import 'package:firebase_database/firebase_database.dart';
import 'package:parking_lots/entity/parking_lots.dart';

class ParkingLotsRepository {
  final DatabaseReference _parkingLotsRef = FirebaseDatabase.instance.reference().child(ParkingLots.COLLECTION_NAME);

  Future<List<ParkingLots>> getAllParkingLot() async{
    List<ParkingLots> result = List();
    DataSnapshot snapshot = await _parkingLotsRef.once();
    Map<dynamic, dynamic> data = snapshot.value;
    data.forEach((key, value) {
      ParkingLots parkingLots = ParkingLots.fromMap(value, key);
      result.add(parkingLots);
    });

    return result;
  }
}