import * as Firebase from 'firebase';
import * as Fs from 'fs';
import * as Path from 'path';
import * as FirebaseConfig from './config/firebase';
import { FirebaseParkingLot } from './entities';

bootstrap();

async function bootstrap() {
  Firebase.initializeApp({
    apiKey: FirebaseConfig.apiKey,
    databaseURL: FirebaseConfig.databaseUrl,
  });

  await Promise.all([initParkingLots(), initBookingPrices()]);

  process.exit();
}

async function initParkingLots() {
  const rawData: {
    name: string;
    lat: number;
    lng: number;
    capacity: number;
    address: string;
  }[] = JSON.parse(
    Fs.readFileSync(
      Path.join(process.cwd(), 'data', 'parkingLots.json'),
    ).toString(),
  );

  await Promise.all(
    rawData
      .map<FirebaseParkingLot>(({ name, lat, lng, address, capacity }) => ({
        name,
        location: {
          lat,
          lng,
          address,
        },
        capacity,
        pendingRequests: [],
        parkingRequests: [],
      }))
      .map(parkingLot => {
        return new Promise(resolve => {
          Firebase.database()
            .ref('parkingLots')
            .push(parkingLot, resolve);
        });
      }),
  );
}

async function initBookingPrices() {
  const rawData: {
    duration: number;
    price: number;
    price6: number;
    price12: number;
  }[] = JSON.parse(
    Fs.readFileSync(
      Path.join(process.cwd(), 'data', 'bookingPrices.json'),
    ).toString(),
  );

  const bookingPrices = rawData
      .reduce((prev, { duration, price, price6, price12 }) => ({
        ...prev,
        [duration]: {
          duration,
        price,
        price6,
        price12,
        }
      }), {})
  Firebase.database().ref("bookingPrices").set(bookingPrices)
}
