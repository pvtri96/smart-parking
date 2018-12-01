import 'package:parking_lots/repository/parking_lots_repository.dart';
import 'package:parking_lots/entity/parking_lots.dart';

class ParkingLotsService {
  final ParkingLotsRepository _parkingLotsRepository = ParkingLotsRepository();

  Future<List<ParkingLots>> getAll() async{
    return await _parkingLotsRepository.getAllParkingLot();
  }

  Future<void> findAndRegisterById(String id) async {
    await _parkingLotsRepository.getParkingLotsById(id);
  }
}