import * as Firebase from 'firebase';
import * as Fs from 'fs';
import * as Path from 'path';
import * as FirebaseConfig from './config/firebase';
import { ParkingLot } from './entities';

function bootstrap() {
  Firebase.initializeApp({
    apiKey: FirebaseConfig.apiKey,
    databaseURL: FirebaseConfig.databaseUrl,
  });

  const rawData: {
    name: string;
    lat: number;
    lng: number;
    capacity: number;
  }[] = JSON.parse(
    Fs.readFileSync(
      Path.join(process.cwd(), 'data', 'parkingLots.json'),
    ).toString(),
  );

  rawData.map<ParkingLot>(({ name, lat, lng, capacity }) => ({
    name,
    location: {
      lat,
      lng,
      address: ""
    },
    capacity,
    pendingRequest: [],
    parkingRequest: []
  })).forEach(parkingLot => {
    Firebase.database().ref("parkingLots").push(parkingLot);
  })
}

bootstrap();
