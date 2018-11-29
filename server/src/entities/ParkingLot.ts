import * as Firebase from 'firebase';
import { Location } from './Coordinate';

export interface ParkingLot {
  name: string;
  location: Location;
  capacity: number;
  parkingRequest: ParkingLotRequest[];
  pendingRequest: ParkingLotRequest[];
}

export interface ParkingLotRequest {
  clientId: string;
  updatedAt: Date;
}

export function findAllParkingLots(): Promise<ParkingLot[]> {
  return new Promise((resolve, reject) => {
    getRef().once("value", snapshot => {
      const rawData = snapshot.val();
      const entities = Object.keys(rawData).map(key => rawData[key]).filter(isParkingLot);
      resolve(entities);
    }, reject)
  })
}

export function findParkingLotsById(id: string): Promise<ParkingLot> {
  return  new Promise((resolve, reject) => {
    getRef().child(id).once("value", snapshot => {
      const rawData = snapshot.val();
      if(isParkingLot(rawData)) {
        resolve(rawData);
      } else {
        reject(rawData)
      }
    }, reject)
  })
}

/**
 * Get reference of the database
 */
function getRef() {
  return Firebase.database().ref("parkingLots")
}

/**
 * Parking Lot object validation
 */
function isParkingLot(object: any): object is ParkingLot {
  if(object.name && object.location && object.location.lat && object.location.lng) {
    return true
  }

  return false;
}
