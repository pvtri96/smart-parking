import * as Firebase from 'firebase';
// import * as Config from './config/certificate';
import { RequestHandler } from './handlers';
function bootstrap() {
  Firebase.initializeApp({
    apiKey: "AIzaSyBoU3Fl8SqbpcG5IuUL7BeTdVey6adZcSM",
    databaseURL: "https://api-project-211707321887.firebaseio.com/"
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
