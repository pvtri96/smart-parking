import * as Firebase from 'firebase';
import * as Fs from 'fs';
import * as Path from 'path';
import * as FirebaseConfig from './config/firebase';
import { FirebaseParkingLot } from './entities';

async function bootstrap() {
  Firebase.initializeApp({
    apiKey: FirebaseConfig.apiKey,
    databaseURL: FirebaseConfig.databaseUrl,
  });

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
        pendingRequest: [],
        parkingRequest: [],
      }))
      .map(parkingLot => {
        return new Promise(resolve => {
          Firebase.database()
            .ref('parkingLots')
            .push(parkingLot, resolve);
        });
      }),
  );

  process.exit();
}

bootstrap();
