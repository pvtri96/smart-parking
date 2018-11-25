import * as Admin from 'firebase-admin';
import * as Config from './config/certificate';
import { RequestHandler } from './handlers';
function bootstrap() {
  Admin.initializeApp({
    credential: Admin.credential.cert(Config.certification),
    databaseURL: Config.databaseUrl,
  });

  RequestHandler.run();

  // const request = Admin.database().ref('requests');

  // setTimeout(() => {
  //   request.push({
  //     clientId: '19287328',
  //     status: 'requesting',
  //     type: 'HELLO_WORLD',
  //     payload: {
  //       name: 'Tri',
  //     },
  //   });
  // }, 2000);
}

bootstrap();
