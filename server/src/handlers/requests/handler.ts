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
      if (descriptor.statusType.match(request.status)) {
        console.log(`Found a handler function for request ${snapshot.key}. Execute...`, request);
        try {
          if(!descriptor.isValidRequest(request)) {
            console.log(`The request does not meet the requirement of handler, find another handler`, request);
            (request as Request).error = new Error("The request does not meet the requirement of handler");
            continue;
          }
          request = await descriptor.handle(request as Request<any,any,any>); // tslint:disable-line
          // Remove error object if request handle successful
          delete request.error;
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
