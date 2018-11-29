import * as Firebase from 'firebase';
import * as FirebaseConfig from './config/firebase';
import { RequestHandler } from './handlers';
import { getMatrixDistance } from './services/googleMap';

function bootstrap() {
  Firebase.initializeApp({
    apiKey: FirebaseConfig.apiKey,
    databaseURL: FirebaseConfig.databaseUrl
  });

  RequestHandler.run();

  getMatrixDistance({ lat: 16.0702948, lng: 108.2174617 }, [
    { lat: 16.0741673, lng: 108.2112121 },
    { lat: 16.0744083, lng: 108.207111 }
  ])
}

bootstrap();
