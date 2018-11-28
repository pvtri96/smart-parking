import * as Firebase from 'firebase';
import { requestDescriptors } from './descriptors';
import { Request } from './typing';
import * as DefaultValidation from './validation';

export function run() {
  const ref = Firebase.database().ref('requests');

  ref.on('child_added', onRequest);

  async function onRequest(snapshot: Firebase.database.DataSnapshot) {
    let request = snapshot.val();
    if (!DefaultValidation.isValidRequest(request)) {
      console.log(`Invalid request, skip ${snapshot.key}`);

      return;
    }
    console.log(`Retrieve a request ${snapshot.key}`);

    for (const descriptor of requestDescriptors) {
      if (descriptor.statusType.match(request.status) && descriptor.isValidRequest(request)) {
        console.log(`Found a handler function for request ${snapshot.key}. Execute...`, request);
        try {
          request = await descriptor.handle(request as Request<any,any,any>); // tslint:disable-line
          console.log(`Successfully handle request ${snapshot.key}`, request);
        } catch (e) {
          request.error = e;
          console.log(`Error while handling request ${snapshot.key}`, request);
        }
        break;
      }
    }
    if (DefaultValidation.isValidResponse(request)) {
      ref.child(snapshot.key).set(request);
    } else {
      console.log(`Invalid response, skip request ${snapshot.key}`, request);
    }
  }
}
