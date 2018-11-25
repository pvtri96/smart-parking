import * as Admin from 'firebase-admin';
import { controllers } from '../../controllers';
import { RequestStatus } from './type';
import { isValidRequest, isValidResponse } from './validation';

export function run() {
  const ref = Admin.database().ref('requests');

  ref.on('child_added', snapshot => {
    console.log('On child_added', snapshot.val());
  });

  ref
    .orderByChild('status')
    .equalTo(RequestStatus.REQUESTING)
    .on('child_added', onRequest);

  async function onRequest(snapshot: Admin.database.DataSnapshot) {
    const request = snapshot.val();
    if (!isValidRequest(request)) {
      console.log(`Invalid request, skip ${snapshot.key}`);

      return;
    }
    console.log(`Receive a request ${snapshot.key}`, snapshot.val());

    for (const controller of controllers) {
      if (controller.type.match(request.type)) {
        console.log(`Found a handler for request ${snapshot.key}. Execute...`);
        try {
          request.response = await controller.handle(request);
          console.log(`Successfully handle request ${snapshot.key}`);
        } catch (e) {
          request.error = e;
          console.log(`Error while handling request ${snapshot.key}`);
        }
        break;
      }
    }
    request.status = RequestStatus.RESPONDED;
    if (isValidResponse(request)) {
      ref.child(snapshot.key).set(request);
    } else {
      console.log(`Invalid response, skip request ${snapshot.key}`);
    }
  }
}
