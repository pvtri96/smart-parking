import { RequestStatus } from '../status';
import { requestTypeCreator } from '../typing';

interface Payload {
  name: string;
}

interface Response {
  content: string;
}

export const HelloWorldRequestDescriptor = requestTypeCreator<Payload, Response>(
  RequestStatus.REQUEST_HELLO_WORLD,
  async request => {
    const { name } = request.payload;
    const content = `Hello ${name}`;

    return {
      ...request,
      status: RequestStatus.RESPONSE_HELLO_WORLD,
      response: { content },
    };
  },
);
