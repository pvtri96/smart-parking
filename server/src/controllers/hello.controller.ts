import { RequestControllerDescriptor } from '../handlers';

export interface HelloPayload {
  name: string;
}

export interface HelloResponse {
  content: string;
}

export const hello: RequestControllerDescriptor<HelloPayload, HelloResponse> = {
  type: 'HELLO_WORLD',
  async handle({ payload }) {
    const { name } = payload;
    const content = `Hello ${name}`;

    return { content };
  },
};

export const controllers = [hello];
