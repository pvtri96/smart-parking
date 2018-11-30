import * as Firebase from 'firebase';
import { Location } from './Coordinate';

export interface FirebaseParkingLot {
  name: string;
  location: Location;
  capacity: number;
  parkingRequest?: ParkingLotRequest[];
  pendingRequest?: ParkingLotRequest[];
  bookingRequest?: ParkingLotRequest[];

}
export interface ParkingLot extends FirebaseParkingLot {
  id: string;
}

export interface ParkingLotRequest {
  requestId: string;
  clientId: string;
  updatedAt: number;
}

export function findAllParkingLots(): Promise<ParkingLot[]> {
  return new Promise((resolve, reject) => {
    getRef().once(
      'value',
      snapshot => {
        const rawData = snapshot.val();
        const entities = Object.keys(rawData)
          .map(key => ({
            id: key,
            ...rawData[key],
          }))
          .filter(isParkingLot);
        resolve(entities);
      },
      reject,
    );
  });
}

export function findParkingLotsById(id: string): Promise<ParkingLot> {
  return new Promise((resolve, reject) => {
    getRef()
      .child(id)
      .once(
        'value',
        snapshot => {
          const rawData = snapshot.val();
          if (isParkingLot(rawData)) {
            resolve({
              id,
              ...rawData,
            });
          } else {
            reject(new Error('Invalid parking lot'));
          }
        },
        reject,
      );
  });
}

export async function updateParkingLot(parkingLotId: string, updater: (currentValue: ParkingLot) => ParkingLot): Promise<ParkingLot> {
  const parkingLot = await findParkingLotsById(parkingLotId);
  const updatedParkingLot = updater(parkingLot);

  const { id, ...firebaseParkingLot } = updatedParkingLot;
  await getRef().child(id).set(firebaseParkingLot);

  return updatedParkingLot;
}

/**
 * Get reference of the database
 */
function getRef() {
  return Firebase.database().ref('parkingLots');
}

/**
 * Parking Lot object validation
 */
function isParkingLot(object: any): object is ParkingLot {
  if (object.name && object.location && object.location.lat && object.location.lng) {
    return true;
  }

  return false;
}
